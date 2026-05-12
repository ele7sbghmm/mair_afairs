#include <stdio.h>
#include <dlfcn.h>

int main() {
	void* handle;
	void (*func)();
	char* err;

	handle = dlopen("./lib.dylib", RTLD_LAZY);
	if (!handle) {
		fprintf(stderr, "err: %s\n", dlerror());
		return 1;
	}

	dlerror();

	func = (void (*)())dlsym(handle, "library");
	if ((err = dlerror()) != NULL) {
		fprintf(stderr, "dlsym fail");
		return 1;
	}

	func();
	dlclose(handle);

	return 0;
}

