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

model PostsResponse {
  posts: [
    {
      uri: string,
      cid: string,
      author: {
        did: string,
        handle: string,
        displayName: string,
        avatar: string,
        viewer: {
          muted: boolean,
          blockedBy: boolean
        },
        labels: [],
        createdAt: utcDateTime
      },
      record: {
        $type: string,
        createdAt: utcDateTime,
        langs: [],
        reply: {
          parent: {
            cid: string,
            uri: string
          },
          root: {
            cid: string,
            uri: string
          },
          text: string
        }
      },
      replyCount: int32,
      repostCount: int32,
      likeCount: int32,
      quoteCount: int32,
      indexedAt: utcDateTime,
      viewer: {
        threadMuted: boolean,
        embeddingDisabled: boolean
      },
      labels: []
    }
  ],
  cursor: int32
}

model PostRecord {
  repo: string,
  collection: string,
  record: {
    $type: string,
    text: string,
    createdAt: utcDateTime
  }
}

model PostResponse {
  uri: string,
  cid: string,
  commit: {
    cid: string,
    rev: string
  },
  validationStatus: string
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
  @useAuth(BearerAuth)
  op getSession(): SessionResponse;

  @post
  op createSession(@body logonDetails: LogonDetails): SessionResponse;
}
// highlight-end

// highlight-start
@route("/xrpc/app.bsky.feed.")
namespace BlueskyFeed {
  @get
  @useAuth(BearerAuth)
  op searchPosts(q: string): PostsResponse;
}
// highlight-end

// highlight-start
@route("/xrpc/com.atproto.repo.")
namespace BlueskyRepo {
  @post
  @useAuth(BearerAuth)
  op createRecord(@body post: PostRecord): PostResponse;
}
// highlight-end
