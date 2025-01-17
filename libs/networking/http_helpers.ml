open Cohttp
open Cohttp_lwt_unix
(* Below we separate the methods out by async (returns Lwt promise),
   and sync (runs async method in lwt runtime)
*)
(* This way we can use the async methods in the language server,
   and other places too
*)

(*****************************************************************************)
(* Async *)
(*****************************************************************************)

let get_async ?(headers = []) url =
  let headers = Header.of_list headers in
  let%lwt response, body = Client.get ~headers url in
  let%lwt body = Cohttp_lwt.Body.to_string body in
  let status = response |> Response.status |> Code.code_of_status in
  match status with
  | _ when Code.is_success status -> Lwt.return (Ok body)
  | _ when Code.is_error status ->
      let code_str = Code.string_of_status response.status in
      let err = "HTTP GET failed, return code " ^ code_str ^ ":\n" ^ body in
      Logs.debug (fun m -> m "%s" err);
      Lwt.return (Error err)
  | _ ->
      let code_str = Code.string_of_status response.status in
      let err = "HTTP GET failed, return code " ^ code_str ^ ":\n" ^ body in
      Logs.debug (fun m -> m "%s" err);
      Lwt.return (Error err)
  [@@profiling]

let post_async ~body ?(headers = [ ("content-type", "application/json") ]) url =
  let headers = Header.of_list headers in
  let%lwt response, body =
    Client.post ~headers ~body:(Cohttp_lwt.Body.of_string body) url
  in
  let%lwt body = Cohttp_lwt.Body.to_string body in
  let status = response |> Response.status |> Code.code_of_status in
  match status with
  | _ when Code.is_success status -> Lwt.return (Ok body)
  | _ when Code.is_error status ->
      let code_str = Code.string_of_status response.status in
      let err = "HTTP POST failed, return code " ^ code_str ^ ":\n" ^ body in
      Logs.debug (fun m -> m "%s" err);
      Lwt.return (Error (-1, err))
  | _ ->
      let code_str = Code.string_of_status response.status in
      let err = "HTTP POST failed, return code " ^ code_str ^ ":\n" ^ body in
      Logs.debug (fun m -> m "%s" err);
      Lwt.return (Error (-1, err))
  [@@profiling]

(*****************************************************************************)
(* Sync *)
(*****************************************************************************)

(* TODO: extend to allow to curl with JSON as answer *)
let get ?headers url = Lwt_main.run (get_async ?headers url) [@@profiling]

let post ~body ?(headers = [ ("content-type", "application/json") ]) url =
  Lwt_main.run (post_async ~body ~headers url)
  [@@profiling]
