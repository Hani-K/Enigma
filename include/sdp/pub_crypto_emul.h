#ifndef _FIPS_CRYPTO_H
#define _FIPS_CRYPTO_H

#include <sdp/dek_common.h>

#include <linux/list.h>
#include <linux/wait.h>
#include <linux/spinlock.h>

#define OP_RSA_ENC 10
#define OP_RSA_DEC 11
#define OP_DH_DEC 12
#define OP_DH_ENC 13
#define OP_ECDH_DEC 14
#define OP_ECDH_ENC 15

#define PUB_CRYPTO_ERROR 99

typedef struct __cipher_param {
    u32 request_id;
    u8 opcode;
	dek_t in;
	kek_t key;
}cipher_param_t;

typedef struct result {
    u32 request_id;
	u8 opcode;
	s16 ret;
	dek_t dek;
}result_t;

/** The request state */
enum req_state {
	PUB_CRYPTO_REQ_INIT = 0,
	PUB_CRYPTO_REQ_PENDING,
	PUB_CRYPTO_REQ_FINISHED
};

typedef struct pub_crypto_contorl {
	struct list_head pending_list;
	//wait_queue_head_t waitq;
	spinlock_t lock;

	/** The next unique request id */
	u32 reqctr;
}pub_crypto_control_t;

typedef struct pub_crypto_request {
	u32 id;
	u8 opcode;

	struct list_head list;
	/** refcount */
	atomic_t count;

	wait_queue_head_t waitq;

	enum req_state state;

	cipher_param_t cipher_param;

	result_t result;

	/** The request was aborted */
	u8 aborted;
}pub_crypto_request_t;

int rsa_encryptByPub(dek_t *dek, dek_t *edek, kek_t *key);
int rsa_decryptByPair(dek_t *edek, dek_t *dek, kek_t *key);
int dh_decryptEDEK(dek_t *edek, dek_t *dek, kek_t *key);
int dh_encryptDEK(dek_t *dek, dek_t *edek, kek_t *key);
int ecdh_decryptEDEK(dek_t *edek, dek_t *dek, kek_t *key);
int ecdh_encryptDEK(dek_t *dek, dek_t *edek, kek_t *key);
#endif
