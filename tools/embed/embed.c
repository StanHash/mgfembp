/* Any copyright is dedicated to the Public Domain.
 * https://creativecommons.org/publicdomain/zero/1.0/ */

#include <inttypes.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

enum Format
{
    FORMAT_U8,
    FORMAT_U16,
    FORMAT_U32,
};

enum Format ParseFormat(char const * format)
{
    if (format[0] == 'u')
    {
        // u8
        if (format[1] == '8' && format[2] == '\0')
            return FORMAT_U8;

        // u16
        if (format[1] == '1' && format[2] == '6' && format[3] == '\0')
            return FORMAT_U16;

        // u32
        if (format[1] == '3' && format[2] == '2' && format[3] == '\0')
            return FORMAT_U32;
    }

    return -1;
}

static unsigned int const s_bytes_per_unit[] = {
    [FORMAT_U8] = 1,
    [FORMAT_U16] = 2,
    [FORMAT_U32] = 4,
};

static unsigned int const s_units_per_line[] = {
    [FORMAT_U8] = 16,
    [FORMAT_U16] = 12,
    [FORMAT_U32] = 8,
};

int main(int argc, char const * argv[])
{
    if (argc != 3)
    {
        fprintf(stderr, "usage: %s <u8|u16|u32> PATH\n", argv[0]);
        return EXIT_FAILURE;
    }

    char const * format_str = argv[1];
    char const * path = argv[2];

    int format = ParseFormat(format_str);

    if (format < 0)
    {
        fprintf(stderr, "error: invalid format specifier: '%s'.\n", format_str);
        return EXIT_FAILURE;
    }

    FILE * own_file = fopen(path, "rb");

    if (own_file == NULL)
    {
        fprintf(stderr, "error: couldn't open '%s' for binary read.\n", path);
        return EXIT_FAILURE;
    }

    FILE * ref_output = stdout;

    uint8_t buf[0x20];

    unsigned int bytes_per_unit = s_bytes_per_unit[format];
    unsigned int units_per_line = s_units_per_line[format];

    unsigned int bytes_per_line = bytes_per_unit * units_per_line;

    int exit_code = EXIT_SUCCESS;

    for (;;)
    {
        size_t read = fread(buf, 1, bytes_per_line, own_file);

        fprintf(ref_output, "   ");

        for (unsigned int i = 0; i < read; i += bytes_per_unit)
        {
            switch (bytes_per_unit)
            {
                uint32_t unit;

                case 1:
                    unit = buf[i];
                    fprintf(ref_output, " 0x%02" PRIX32 ",", unit);
                    break;

                case 2:
                    unit = buf[i] + (buf[i + 1] << 8);
                    fprintf(ref_output, " 0x%04" PRIX32 ",", unit);
                    break;

                case 4:
                    unit = buf[i] + (buf[i + 1] << 8) + (buf[i + 2] << 16) + (buf[i + 3] << 24);
                    fprintf(ref_output, " 0x%08" PRIX32 ",", unit);
                    break;
            }
        }

        fputc('\n', ref_output);

        if (read != bytes_per_line)
        {
            if (ferror(own_file))
            {
                fprintf(stderr, "error: IO error while reading '%s'.\n", path);
                exit_code = EXIT_FAILURE;
            }
            else if ((read % bytes_per_unit) != 0)
            {
                fprintf(stderr, "error: size of '%s' is not a multiple of %d.\n", path, bytes_per_unit);
                exit_code = EXIT_FAILURE;
            }

            break;
        }
    }

    fclose(own_file);

    return exit_code;
}
