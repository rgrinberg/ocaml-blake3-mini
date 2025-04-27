Inspecting the archive:

$ nm ../vendor/libblake3.a

  $ cat > test.c <<'EOF'
  > #include <stdio.h>
  > extern char* blake3_version();
  > int main() {
  >   printf("BLAKE3 version: %s\n", blake3_version());
  >   return 0;
  > }
  > EOF

  $ cc test.c ../vendor/libblake3.a -o test
  $ ./test
  BLAKE3 version: 1.8.1
