;; DAO Membership Contract
(impl-trait .dao-traits.dao-membership-trait)

;; Constants
(define-constant err-not-member (err u200))
(define-constant err-already-member (err u201))

;; NFT definition
(define-non-fungible-token dao-membership uint)

;; Data maps
(define-map members
  { dao-id: uint, member: principal }
  { joined-at: uint, role: (string-ascii 32) }
)

;; Public functions
(define-public (join-dao (dao-id uint))
  (let ((existing-membership (map-get? members { dao-id: dao-id, member: tx-sender })))
    (asserts! (is-none existing-membership) err-already-member)
    (try! (nft-mint? dao-membership dao-id tx-sender))
    (ok (map-set members
      { dao-id: dao-id, member: tx-sender }
      { joined-at: block-height, role: "member" }))
  )
)
