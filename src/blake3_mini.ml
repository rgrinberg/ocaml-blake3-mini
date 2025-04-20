module Digest = struct
  type t = string

  let to_binary x = x
  let to_hex x = x
end

type t

external create : unit -> t = "blake3_mini_create"

external reset : t -> unit = "blake3_mini_reset"

external digest : t -> Digest.t = "blake3_mini_digest"

external feed_string : t -> string -> pos:int -> len:int -> unit = "blake3_mini_feed_string"

external feed_bytes : t -> bytes -> pos:int -> len:int -> unit = "blake3_mini_feed_string"

external fd : Unix.file_descr -> string = "blake3_mini_fd"
