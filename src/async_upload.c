#include "async_upload.h"

#include "gbadma.h"

#define UPLOAD_LIST_COUNT 0x20

enum
{
    UPLOAD_MODE_COPY_SLOW,
    UPLOAD_MODE_COPY_FAST,
    UPLOAD_MODE_FILL_FAST,
};

struct AsyncUploadInfo
{
    /* 00 */ i32 count;
    /* 04 */ i32 summed_size;
};

struct AsyncUploadEnt
{
    /* 00 */ void const * src;
    /* 04 */ void * dst;
    /* 08 */ u16 size;
    /* 0A */ u16 mode;
};

struct AsyncUploadInfo EWRAM_DATA gAsyncUploadInfo = { 0 };
struct AsyncUploadEnt EWRAM_DATA gAsyncUploadList[UPLOAD_LIST_COUNT] = { 0 };

void ClearAsyncUploadList(void)
{
    int i;

    gAsyncUploadInfo.count = 0;
    gAsyncUploadInfo.summed_size = 0;

    for (i = 0; i < UPLOAD_LIST_COUNT; ++i)
    {
        gAsyncUploadList[i].src = NULL;
        gAsyncUploadList[i].dst = NULL;
        gAsyncUploadList[i].size = 0;
        gAsyncUploadList[i].mode = 0;
    }

    gAsyncUploadList[0].src = 0;
}

void AsyncDataUpload(void const * src, void * dst, int size)
{
    struct AsyncUploadEnt * ent = gAsyncUploadList + gAsyncUploadInfo.count;

    ent->src = src;
    ent->dst = dst;
    ent->size = size;
    ent->mode = ((size & 0x1F) != 0) ? UPLOAD_MODE_COPY_SLOW : UPLOAD_MODE_COPY_FAST;

    gAsyncUploadInfo.summed_size += size;
    gAsyncUploadInfo.count++;
}

void AsyncDataFill(u32 value, void * dst, int size)
{
    struct AsyncUploadEnt * ent = gAsyncUploadList + gAsyncUploadInfo.count;

    ent->src = (void const *)value;
    ent->dst = dst;
    ent->size = size;
    ent->mode = UPLOAD_MODE_FILL_FAST;

    gAsyncUploadInfo.summed_size += size;
    gAsyncUploadInfo.count++;
}

void ApplyAsyncUploads(void)
{
    struct AsyncUploadEnt * it = gAsyncUploadList;
    int i;

    for (i = 0; i < gAsyncUploadInfo.count; ++i)
    {
        switch (it->mode)
        {
            case UPLOAD_MODE_COPY_SLOW:
                CpuCopy16(it->src, it->dst, it->size);
                break;

            case UPLOAD_MODE_COPY_FAST:
                CpuFastCopy(it->src, it->dst, it->size);
                break;

            case UPLOAD_MODE_FILL_FAST:
                CpuFastFill((u32)it->src, it->dst, it->size);
                break;
        }

        it++;
    }

    ClearAsyncUploadList();
}
