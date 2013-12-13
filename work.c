#include <string.h>

static int cursor_x = 0;
static int cursor_y = 0;
static char * const videomem = (char*)0xb8000;

void * memcpy(void *restrict to, const void *restrict from, size_t num) {
    register size_t n = (num + 7) / 8;
    void * saved_to = to;
    switch(num % 8) {
    case 0: do {    *((char*)to++) = *((char*)from++);
        case 7:         *((char*)to++) = *((char*)from++);
        case 6:         *((char*)to++) = *((char*)from++);
        case 5:         *((char*)to++) = *((char*)from++);
        case 4:         *((char*)to++) = *((char*)from++);
        case 3:         *((char*)to++) = *((char*)from++);
        case 2:         *((char*)to++) = *((char*)from++);
        case 1:         *((char*)to++) = *((char*)from++);
        } while(--n > 0);
    }
    return saved_to;
}

void* memmove(void * to, const void * from, size_t num) {
    register size_t i;
    void * saved_to = to;
    if (from + num > to) {
        register void* ptr_to = to + num - 1;
        register const void* ptr_from = from + num - 1;
        while (ptr_to >= to) {
            *((char*)ptr_to--) = *((char*)ptr_from--);
        }
    } else {
        for (i = 0; i < num; ++i) {
            *((char*)to++) = *((char*)from++);
        }
    }

    return saved_to;
}
    

void clear_screen() {
    int i;
    for (i = 0; i < (80 * 25 * 2); ++i) videomem[i] = (char)0;
}

void scroll_screen() {
    memmove(videomem, videomem + 160, 80*25*2);
}

void write_char(const char ch, const char attr) {
    if (ch == 0x10) {
        ++cursor_y;
        cursor_x = 0;
        if (cursor_y >= 24) {
            scroll_screen();
        }
        return;
    }
            
    videomem[(80*cursor_y + cursor_x)*2] = ch;
    videomem[(80*cursor_y + cursor_x)*2 + 1] = attr;
    ++cursor_x;
    if (cursor_x == 80) {
        ++cursor_y;
        if (cursor_y >= 24) {
            scroll_screen();
            cursor_x = 0;
        }
    }
}

void write_string(const char * s) { /* ASCIZ */
    while (*s != (char)0) {
        write_char(*s++, 0x0f);
    }
}
