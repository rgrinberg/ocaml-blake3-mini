#include <caml/alloc.h>
#include <caml/custom.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <caml/threads.h>
#include <caml/unixsupport.h>

#include <unistd.h>

#include "blake3.h"

#define Blake3_val(v) (*(blake3_hasher **)Data_custom_val(v))

static inline value alloc_hash(blake3_hasher *hasher, int len) {
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

static void blake3_mini_finalize(value v_t) {
  blake3_hasher *hasher = Blake3_val(v_t);
  caml_stat_free(hasher);
}

static struct custom_operations blake3_mini_t_ops = {
    "blake3.mini.stream",       blake3_mini_finalize,
    custom_compare_default,     custom_hash_default,
    custom_serialize_default,   custom_deserialize_default,
    custom_compare_ext_default, custom_fixed_length_default};

CAMLprim value blake3_mini_create(value v_unit) {
  CAMLparam1(v_unit);
  CAMLlocal1(v_ret);

  blake3_hasher hasher;
  blake3_hasher_init(&hasher);

  value v_t =
      caml_alloc_custom(&blake3_mini_t_ops, sizeof(blake3_hasher *), 0, 1);

  CAMLreturn(v_t);
}

CAMLprim value blake3_mini_reset(value v_t) {
  CAMLparam1(v_t);

  blake3_hasher *hasher = Blake3_val(v_t);
  blake3_hasher_reset(hasher);

  CAMLreturn(Val_unit);
}

CAMLprim value blake3_mini_digest(value v_t) {
  CAMLparam1(v_t);
  CAMLlocal1(v_ret);

  blake3_hasher *hasher = Blake3_val(v_t);
  v_ret = alloc_hash(hasher, 16);

  CAMLreturn(v_ret);
}

CAMLprim value blake3_mini_feed_string(value v_t, value v_s, value v_pos, value v_len) {
  CAMLparam4(v_t, v_s, v_pos, v_len);

  blake3_hasher *hasher = Blake3_val(v_t);
  size_t len = Int_val(v_len);
  size_t pos = Int_val(v_pos);
  char *s = String_val(v_s);
  blake3_hasher_update(hasher, s + pos, len);

  CAMLreturn(Val_unit);
}
