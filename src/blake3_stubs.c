#include <caml/alloc.h>
#include <caml/custom.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <caml/threads.h>
#include <caml/unixsupport.h>

#include <unistd.h>

#include "blake3.h"

static inline value alloc_hash(blake3_hasher* hasher, int len) {
  value v_ret = caml_alloc_string(len);
  blake3_hasher_finalize(hasher, String_val(v_ret), len);
  return v_ret;
}

CAMLprim value blake3_mini_fd(value v_fd) {
  CAMLparam1(v_fd);
  CAMLlocal1(v_ret);
  int fd = Int_val(v_fd);
  caml_release_runtime_system();

  blake3_hasher hasher;
  blake3_hasher_init(&hasher);

  char buffer[UNIX_BUFFER_SIZE];
  size_t count;
  while ((count = read(fd, buffer, sizeof(buffer))) != 0) {
    blake3_hasher_update(&hasher, buffer, count);
  }

  caml_acquire_runtime_system();
  v_ret = alloc_hash(&hasher, 16);
  CAMLreturn(v_ret);
}
