#include <stdbool.h>
#include <stdio.h>
#include <string.h>

static const size_t BUFFER_SIZE = 1000;

bool is_all_whitespace(const char *str, size_t length) {
    for (size_t i = 0; i < length; i++) {
        if (str[i] != ' ' || str[i] != '\t' || str[i] != '\n') {
            return false;
        }
    }

    return true;
}

void print_escaped_json_string(const char *c_str, size_t length) {
    char str[BUFFER_SIZE];
    strcpy(str, c_str);

    if (length > 0 && str[length-1] == '\n') {
        str[length - 1] = '\0';
        length--;
    }

    size_t last_split = 0;
    for (size_t i = 0; i < length; i++) {
        if (str[i] == '"' || str[i] == '\\') {
            char buf = str[i];
            str[i] = '\0';
            fputs(str + last_split, stdout);
            last_split = i + 1;
            printf("\\%c", buf);
        }
    }

    if (last_split < length) {
        fputs(str + last_split, stdout);
    }
}

void print_matches_string(const char *str, size_t length) {
    const char *delim = "[]()-/\"'";
    char buf[BUFFER_SIZE];
    strcpy(buf, str);
    char *token = strtok(buf, delim);

    while (token != NULL) {
        putc(' ', stdout);
        print_escaped_json_string(token, strlen(token));
        token = strtok(NULL, delim);
    }
}

int main(int argc, const char* argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage %s <bookmarks.md>\n", argv[0]);
        return 1;
    }

    FILE *f = fopen(argv[1], "r");

    if (!f) {
        fprintf(stderr, "Can't open %s for reading.\n", argv[1]);
        return 2;
    }

    printf(
        "{\n"
        "  \"items\":[\n"
    );

    char buf[BUFFER_SIZE];
    char title[BUFFER_SIZE];
    size_t title_length = 0;
    size_t line_number = 0;
    size_t sequence = 0;
    bool is_first_item = true;

    while (fgets(buf, BUFFER_SIZE, f)) {
        line_number++;
        size_t length = strlen(buf);

        if (length >= BUFFER_SIZE) {
            fprintf(stderr, "Line %zd exceeded maximum buffer size (%zd characters), terminating the program.\n", line_number, BUFFER_SIZE);
            return 3;
        }

        if (length == 1 || buf[0] == '#' || is_all_whitespace(buf, length)) {
            continue;
        }

        switch (sequence) {
            case 0:
                strcpy(title, buf);
                title_length = length;
                sequence++;
                break;
            case 1:
                sequence = 0;
                if (!is_first_item) {
                    printf(",\n");
                }
                printf("    {\"title\":\"");
                print_escaped_json_string(title, title_length);
                printf("\",\"subtitle\":\"");
                print_escaped_json_string(buf, length);
                printf("\",\"arg\":\"");
                print_escaped_json_string(buf, length);
                printf("\",\"matches\":\"");
                print_matches_string(title, title_length);
                printf("\"}");
                is_first_item = false;
                break;
        }
    }

    if (!is_first_item) {
        printf(",");
    }

    printf(
        "\n"
        "    {\"title\":\"Edit bookmarks\", \"subtitle\": \"Open bookmarks.md\", \"arg\":\"edit\" }"
        "  ]\n"
        "}\n"
    );

    if (sequence != 0) {
        fprintf(stderr, "Warning: unbalanced file. Produced output may be incorect.\n");
        return 4;
    }

    return 0;
}
