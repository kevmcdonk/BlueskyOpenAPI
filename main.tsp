import "@typespec/http";
import "@typespec/rest";

@service({
  title: "Bluesky",
})
@server("https://bsky.social")

namespace BlueskyService;

using TypeSpec.Http;
using TypeSpec.Rest;



model LogonDetails {
  @key identifier: string,
  "password": string
}

model SessionResponse {
    did: string,
    didDoc: {
      context: [],
      id: string,
      alsoKnownAs: [],
      verificationMethod: [
            {
                id: string,
                type: string,
                controller: string,
                publicKeyMultibase: string
            }
        ],
        service: [
            {
                id: string,
                type: string,
                serviceEndpoint: string
            }
        ]
    },
    handle: string,
    email: string,
    mailConfirmed: boolean,
    emailAuthFactor: boolean,
    accessJwt: string,
    refreshJwt: string,
    active: boolean
}

@error
model Error {
  code: int32;
  message: string;
}


// highlight-start
@route("/xrpc/com.atproto.server.")
namespace BlueskyServer {
  @get
  op getSession(): SessionResponse;

  @post
  op createSession(@body logonDetails: LogonDetails): SessionResponse;
}
// highlight-end
