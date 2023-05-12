#ifndef ASYNC_UPLOAD_H
#define ASYNC_UPLOAD_H

// this defines a number of utility functions for uploading data to VRAM or other memories asynchroneously.
// the actual uploading would happen on VBlank, in order to prevent atrifacts that would occur when doing do
// mid-display.

#include "common.h"

void ClearAsyncUploadList(void);
void AsyncDataUpload(void const * src, void * dst, int size);
void AsyncDataFill(u32 value, void * dst, int size);
void ApplyAsyncUploads(void);

#define AsyncDataUploadVram(src, offset, size) AsyncDataUpload((src), VRAM + (0x1FFFF & (offset)), (size))
#define AsyncDataFillVram(value, offset, size) AsyncDataFill((value), VRAM + (0x1FFFF & (offset)), (size))

#endif // ASYNC_UPLOAD_H
