module Digest = struct
  type t = string

  let equal = String.equal
  let compare = String.compare
  let to_binary x = x

  let to_hex d =
    (* Ripped off from the stdlib's [Digest.to_hex] *)
    let char_hex n =
      Char.chr (if n < 10 then Char.code '0' + n else Char.code 'a' + n - 10)
    in
    let len = String.length d in
    let result = Bytes.create (len * 2) in
    for i = 0 to len - 1 do
      let x = Char.code d.[i] in
      Bytes.unsafe_set result (i * 2) (char_hex (x lsr 4));
      Bytes.unsafe_set result ((i * 2) + 1) (char_hex (x land 0x0f))
    done;
    Bytes.unsafe_to_string result
  ;;
end

type t

external create : unit -> t = "blake3_mini_create"
external reset : t -> unit = "blake3_mini_reset"
external digest : t -> Digest.t = "blake3_mini_digest"

external feed_string
  :  t
  -> string
  -> pos:int
  -> len:int
  -> unit
  = "blake3_mini_feed_string"

external feed_bytes : t -> bytes -> pos:int -> len:int -> unit = "blake3_mini_feed_string"

external feed_bigstring_release_lock
  :  t
  -> (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t
  -> pos:int
  -> len:int
  -> unit
  = "blake3_mini_feed_bigstring_unlock"

external fd : Unix.file_descr -> string = "blake3_mini_fd"
