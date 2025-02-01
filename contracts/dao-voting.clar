;; DAO Voting Contract
(impl-trait .dao-traits.dao-voting-trait)

;; Constants
(define-constant err-proposal-not-found (err u300))
(define-constant err-already-voted (err u301))

;; Data maps
(define-map proposals
  { proposal-id: uint }
  {
    title: (string-ascii 128),
    description: (string-utf8 512),
    creator: principal,
    created-at: uint,
    expires-at: uint,
    yes-votes: uint,
    no-votes: uint,
    status: (string-ascii 16)
  }
)

;; Public functions
(define-public (create-proposal 
  (title (string-ascii 128))
  (description (string-utf8 512))
  (duration uint))
  (let ((proposal-id (+ (var-get current-proposal-id) u1)))
    (ok (map-set proposals
      { proposal-id: proposal-id }
      {
        title: title,
        description: description,
        creator: tx-sender,
        created-at: block-height,
        expires-at: (+ block-height duration),
        yes-votes: u0,
        no-votes: u0,
        status: "active"
      }))
  )
)
