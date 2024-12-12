
(impl-trait 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.nft-trait.nft-trait)


(define-non-fungible-token my-first-nft uint)


(nft-mint? my-first-nft u1 tx-sender)


(nft-transfer? my-first-nft u1 tx-sender 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5)

(print (nft-get-owner? my-first-nft u1))


(define-constant contract-owner tx-sender)
(define-constant token-name "my-first-nft")
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))

(define-data-var last-token-id uint u0)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
    (begin 
        (asserts! (is-eq tx-sender sender) err-not-token-owner)
        (nft-transfer? my-first-nft token-id sender recipient)
    )
)

(define-read-only (get-owner (token-id uint)) 
    (ok (nft-get-owner? my-first-nft token-id))
)

(define-read-only (get-last-token-id) 
    (ok (var-get last-token-id))
)

(define-read-only (get-token-uri (token-id uint)) 
    (ok none)
)

(define-read-only (get-token-name) 
    (ok (concat token-name ""))
)

