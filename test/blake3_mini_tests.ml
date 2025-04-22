let printf = Printf.printf

let test_string =
  let in_ = open_in "somefile" in
  let res = input_line in_ in
  close_in in_;
  res

let%expect_test "128 bits fd" =
  let fd = Unix.openfile "somefile" [] 0 in
  let hash = Blake3_mini.fd fd in
  Unix.close fd;
  printf "%S\n" (Blake3_mini.Digest.to_hex hash);
  [%expect {| "7a7d692dfca02a756fea9a8a77903807" |}]

let%expect_test "digest with hasher" =
  let chan = open_in "somefile" in
  let size = in_channel_length chan in
  let contents = really_input_string chan size in
  close_in chan;
  let hasher = Blake3_mini.create () in
  Blake3_mini.feed_string hasher contents ~pos:0 ~len:(String.length contents);
  let digest = Blake3_mini.digest hasher in
  printf "%S\n" (Blake3_mini.Digest.to_hex digest);
  [%expect{| "7a7d692dfca02a756fea9a8a77903807" |}]
