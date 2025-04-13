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
  printf "%S\n" hash;
  [%expect {| "z}i-\252\160*uo\234\154\138w\1448\007" |}]
