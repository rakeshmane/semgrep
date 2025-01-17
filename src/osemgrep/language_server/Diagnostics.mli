val diagnostics_of_results :
  Semgrep_output_v1_t.cli_match list ->
  Fpath.t list ->
  Lsp.Server_notification.t list
(** [diagnostics_of_results results files] returns a list of LSP diagnostics
    for the given matches. A diagnostic is the little squiggly you see under
    an error in your editor.

    See:
    https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_publishDiagnostics
 *)

(* Example:
   {
         "code": "python.cryptography.security.insecure-hash-algorithms.insecure-hash-algorithm-sha1",
         "codeDescription": {
             "href": "https://sg.run/J9Qy"
         },
         "message": "Detected SHA1 hash algorithm which is considered insecure. SHA1 is not collision resistant and is therefore not suitable as a cryptographic signature. Use SHA256 or SHA3 instead.",
         "range": {
             "end": {
                 "character": 11,
                 "line": 9
             },
             "start": {
                 "character": 7,
                 "line": 9
             }
         },
         "severity": 2,
         "source": "Semgrep"
   }
*)
