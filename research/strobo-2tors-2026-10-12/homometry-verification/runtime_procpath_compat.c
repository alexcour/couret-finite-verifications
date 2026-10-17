#define _GNU_SOURCE
#include <dlfcn.h>
#include <unistd.h>
#include <string.h>
#include <ctype.h>
ssize_t readlink(const char *path, char *buf, size_t size) {
  static ssize_t (*original)(const char*, char*, size_t);
  if (!original) original = dlsym(RTLD_NEXT, "readlink");
  if (strncmp(path,"/proc/",6)==0 && isdigit(path[6]) && strstr(path,"/exe"))
    return original("/proc/self/exe",buf,size);
  return original(path,buf,size);
}
