let () =
  let file = Sys.argv.(1) in
  let fd = Unix.openfile file [] 0 in
  let hash = Blake3_mini.fd fd in
  Unix.close fd;
  print_endline (Blake3_mini.Digest.to_hex hash)
;;

