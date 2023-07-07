# Sui CLI

## Commands

- Create a keypair: `sui keytool generate <scheme>`; generates a `<address>.key` file in the current directory.

  ```sh
  ❯ sui keytool generate ed25519
  Created new keypair for address wrote to file path "0x41521fe1eac5994e89b45c76ec2fa5bc2d3370fc28fe4d04ec052c4579afd437.key" with scheme ED25519: [0x41521fe1eac5994e89b45c76ec2fa5bc2d3370fc28fe4d04ec052c4579afd437]
  Secret Recovery Phrase : [diet palm young river entry section cushion pencil pool speed boss casual]
  ```

  Here, the public key is the address & the private key is the secret recovery phrase.

- Show the details of `<address>.key` file:

  ```sh
  ❯ sui keytool show 0x41521fe1eac5994e89b45c76ec2fa5bc2d3370fc28fe4d04ec052c4579afd437.key
  Public Key: AEXK7ZBH1+l+/uZJTtKnZtVKu7FpQNC/+KZsLY0sNmWr
  Flag: 0
  PeerId: 45caed9047d7e97efee6494ed2a766d54abbb16940d0bff8a66c2d8d2c3665ab
  ```

- Convert an public key to address: `sui keytool base64-pub-key-to-address <base64-pub-key>`

  ```sh
  ❯ sui keytool base64-pub-key-to-address AEXK7ZBH1+l+/uZJTtKnZtVKu7FpQNC/+KZsLY0sNmWr
  Address 0x41521fe1eac5994e89b45c76ec2fa5bc2d3370fc28fe4d04ec052c4579afd437
  ```

  ```mermaid
  graph LR
  A[secret recovery phrase] --schemes--> B[public key] --base64--> C[address]
  ```

  Here, schemes

  - Ed25519
  - ECDSA Secp256k1
  - ECDSA Secp256r1

More on this [here](https://docs.sui.io/learn/cryptography/sui-wallet-specs#).

- Interactive console via `$ sui console`. By default it is connected to `devnet` & `ed25519` wallet scheme. 1 address is created by default.

    <details>
    <summary>Console:</summary>

  ```sh
  ❯ sui console
  _____       _    ______                       __
  / ___/__  __(_)  / ____/___  ____  _________  / /__
  \__ \/ / / / /  / /   / __ \/ __ \/ ___/ __ \/ / _ \
  ___/ / /_/ / /  / /___/ /_/ / / / (__  ) /_/ / /  __/
  /____/\__,_/_/   \____/\____/_/ /_/____/\____/_/\___/
  --- Sui Console 1.5.0 ---

  Managed addresses : 1
  Active address: 0x8833b9cff8032ddf6eb52dd5fe82d9708f53f0d2a89d7ba5e94ba01fcca3c7dc
  Keystore Type : File
  Keystore Path : Some("~/.sui/sui_config/sui.keystore")
  Active environment : devnet
  RPC URL: https://fullnode.devnet.sui.io:443
  Connecting to Sui full node. API version 1.5.0

  Available RPC methods: ["sui_devInspectTransactionBlock", "sui_dryRunTransactionBlock", "sui_executeTransactionBlock", "sui_getChainIdentifier", "sui_getCheckpoint", "sui_getCheckpoints", "sui_getEvents", "sui_getLatestCheckpointSequenceNumber", "sui_getLoadedChildObjects", "sui_getMoveFunctionArgTypes", "sui_getNormalizedMoveFunction", "sui_getNormalizedMoveModule", "sui_getNormalizedMoveModulesByPackage", "sui_getNormalizedMoveStruct", "sui_getObject", "sui_getProtocolConfig", "sui_getTotalTransactionBlocks", "sui_getTransactionBlock", "sui_multiGetObjects", "sui_multiGetTransactionBlocks", "sui_tryGetPastObject", "sui_tryMultiGetPastObjects", "suix_getAllBalances", "suix_getAllCoins", "suix_getBalance", "suix_getCoinMetadata", "suix_getCoins", "suix_getCommitteeInfo", "suix_getDynamicFieldObject", "suix_getDynamicFields", "suix_getLatestSuiSystemState", "suix_getOwnedObjects", "suix_getReferenceGasPrice", "suix_getStakes", "suix_getStakesByIds", "suix_getTotalSupply", "suix_getValidatorsApy", "suix_queryEvents", "suix_queryTransactionBlocks", "suix_resolveNameServiceAddress", "suix_resolveNameServiceNames", "suix_subscribeEvent", "suix_subscribeTransaction", "unsafe_batchTransaction", "unsafe_mergeCoins", "unsafe_moveCall", "unsafe_pay", "unsafe_payAllSui", "unsafe_paySui", "unsafe_publish", "unsafe_requestAddStake", "unsafe_requestWithdrawStake", "unsafe_splitCoin", "unsafe_splitCoinEqual", "unsafe_transferObject", "unsafe_transferSui"]

  Welcome to the Sui interactive console.

  sui>-$ help
  sui>-$ addresses
  Showing 2 results.
  0x8833b9cff8032ddf6eb52dd5fe82d9708f53f0d2a89d7ba5e94ba01fcca3c7dc <=
  0xdd72cf212af07beb9ebc132e01f6398858c623aae8e7a9e7e6f9c09d279c65ab
  sui>-$ new-address ed25519
  Created new keypair for address with scheme ED25519: [0x7e86320466e04f808a5e046a65d1458b3a28def339ea9986e5874496ef66bd08]
  Secret Recovery Phrase : [scale adult universe quit cheap harbor pupil bean simple piece collect guide]
  sui>-$ envs
  devnet => https://fullnode.devnet.sui.io:443 (active)
  sui>-$ active-address
  0x8833b9cff8032ddf6eb52dd5fe82d9708f53f0d2a89d7ba5e94ba01fcca3c7dc
  sui>-$ active-env
  devnet
  sui>-$ chain-identifier
  c42d763f
  sui>-$ exit
  Bye!

  ```

    </details>
  The keystore file is created in the home directory by default. Press <kbd>tab</kbd> to go to the next sorted command (alphabetically ordered) & <kbd>shift+tab</kbd> to go back to the previous sorted command.

New address can be generated inside this keystore via `new-address` command.

- Non-interactive console via `$ sui client <command>`. The environment can be accessed from outside REPL type shell as shown above.
- Get faucet in devnet

```sh
❯ curl --location --request POST 'https://faucet.devnet.sui.io/gas' \
--header 'Content-Type: application/json' \
--data-raw '{
    "FixedAmountRequest": {
        "recipient": "0x7e86320466e04f808a5e046a65d1458b3a28def339ea9986e5874496ef66bd08"
    }
}'
{"transferredGasObjects":[{"amount":10000000000,"id":"0xfd0d7fa2823b4874a9f4e269bb99fed66819dd66feebd09d710aaf49ace085c2","transferTxDigest":"ejRpvHknJUzb6pP4hVurrwcRDRLNv78egPai4BMQ5ev"}],"error":null}%
```

- switch to an address (in keystore):

  ```sh
  ❯ sui client switch --address 0x7e86320466e04f808a5e046a65d1458b3a28def339ea9986e5874496ef66bd08
  Active address switched to 0x7e86320466e04f808a5e046a65d1458b3a28def339ea9986e5874496ef66bd08
  ```

- Get objects of active address (in keystore)

  ```sh
  ❯ sui client objects
                  Object ID                  |  Version   |                    Digest                    |   Owner Type    |               Object Type
  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  0xfd0d7fa2823b4874a9f4e269bb99fed66819dd66feebd09d710aaf49ace085c2 |     76     | cj4WkR/YSk6fw/rUFHNAICYcmt3z45bszYGqYqSUIH4= |  AddressOwner   |  Some(Struct(MoveObjectType(GasCoin)))
  Showing 1 results.
  ```

- Get objects of an address

  ```sh
  ❯ sui client objects 0x8833b9cff8032ddf6eb52dd5fe82d9708f53f0d2a89d7ba5e94ba01fcca3c7dc
                  Object ID                  |  Version   |                    Digest                    |   Owner Type    |               Object Type
  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  0x0f9f08be42a5b623b204322b09faa0899520b40789df46db1fbb6a1ada963af9 |     76     | DraVhn2hRdSNVperHSIqJXMu6Gn61ecw+diRN+cjtoI= |  AddressOwner   |  Some(Struct(MoveObjectType(GasCoin)))
  0x1ef51f11dd6ee2659be81dafcd87b261b660d084c3b385510e5b2ee218fd04ec |     76     | DHluVaaFBUIPRNIVTapPhGIOErGF8hUMBbPjqYs1Reg= |  AddressOwner   |  Some(Struct(MoveObjectType(GasCoin)))
  0xde3246ec48a42b7bc0bda7bd8cb73c41c8e77189dfb4d068fb11009d5cde3b97 |     76     | 2oxfXyzQARbcnxGY+LrCyY5oLxbpSYNPTSoK1KHmFOs= |  AddressOwner   |  Some(Struct(MoveObjectType(GasCoin)))
  Showing 3 results.
  ```

- Get an object details with id:

  ```sh
  ❯ sui client object 0x1ef51f11dd6ee2659be81dafcd87b261b660d084c3b385510e5b2ee218fd04ec
  ----- 0x2::coin::Coin<0x2::sui::SUI> (0x1ef51f11dd6ee2659be81dafcd87b261b660d084c3b385510e5b2ee218fd04ec[0x4c]) -----
  Owner: Account Address ( 0x8833b9cff8032ddf6eb52dd5fe82d9708f53f0d2a89d7ba5e94ba01fcca3c7dc )
  Version: 0x4c
  Storage Rebate: 988000
  Previous Transaction: TransactionDigest(4u8FFpMScUPPtT8H8Y6uZE5ZzVE1bkYjhvfrdTXyWuSg)
  ----- Data -----
  type: 0x2::coin::Coin<0x2::sui::SUI>
  balance: 10000000000
  id: 0x1ef51f11dd6ee2659be81dafcd87b261b660d084c3b385510e5b2ee218fd04ec
  ```

- Get an object details with id (in JSON format)

  ```sh
  ❯ sui client object 0x1ef51f11dd6ee2659be81dafcd87b261b660d084c3b385510e5b2ee218fd04ec --json
  {
  "objectId": "0x1ef51f11dd6ee2659be81dafcd87b261b660d084c3b385510e5b2ee218fd04ec",
  "version": "76",
  "digest": "qhHczL9tuhdaQZ73LTz7ZW3PfjuwXykmGLbyUdEpCE3",
  "type": "0x2::coin::Coin<0x2::sui::SUI>",
  "owner": {
      "AddressOwner": "0x8833b9cff8032ddf6eb52dd5fe82d9708f53f0d2a89d7ba5e94ba01fcca3c7dc"
  },
  "previousTransaction": "4u8FFpMScUPPtT8H8Y6uZE5ZzVE1bkYjhvfrdTXyWuSg",
  "storageRebate": "988000",
  "content": {
      "dataType": "moveObject",
      "type": "0x2::coin::Coin<0x2::sui::SUI>",
      "hasPublicTransfer": true,
      "fields": {
      "balance": "10000000000",
      "id": {
          "id": "0x1ef51f11dd6ee2659be81dafcd87b261b660d084c3b385510e5b2ee218fd04ec"
      }
      }
  }
  }
  ```

- View the object transfer from `0x7e86320466e04f808a5e046a65d1458b3a28def339ea9986e5874496ef66bd08` to `0x8833b9cff8032ddf6eb52dd5fe82d9708f53f0d2a89d7ba5e94ba01fcca3c7dc`. Here, view the objects -> transfer an object -> view the objects

<details>
<summary><b>Details:</b></summary>

```sh
========
❯ sui client objects
Object ID | Version | Digest | Owner Type | Object Type

---

0x67e786d94eac270580eca1a5364b55efa59586ba6776e560bbae078ef82e5d8b | 82 | DMvt64lgv3Y3md4c3VVpl7FzHJ+J4OF5ZwkkzMCl9d8= | AddressOwner | Some(Struct(MoveObjectType(GasCoin)))
 0x9d51acc8e1680392a6b46f1ca1f205ff4aa5557ee5564460283dc46a17a15c04 | 76 | AaGjcUdg4/ske5IAGgM5TGcC5HgukVCQ1RuP6DA8DHg= | AddressOwner | Some(Struct(MoveObjectType(GasCoin)))
Showing 2 results.

========
❯ sui client transfer --to 0x8833b9cff8032ddf6eb52dd5fe82d9708f53f0d2a89d7ba5e94ba01fcca3c7dc --object-id 0x9d51acc8e1680392a6b46f1ca1f205ff4aa5557ee5564460283dc46a17a15c04 --gas-budget 10000000
----- Transaction Digest ----
J8sAi6q1HvT8sdRwFKWefY7WVJoicYEeu9vtQ2t5Mde4
----- Transaction Data ----
Transaction Signature: [Signature(Ed25519SuiSignature(Ed25519SuiSignature([0, 127, 236, 244, 178, 6, 140, 151, 182, 244, 18, 137, 123, 145, 26, 225, 241, 46, 35, 215, 162, 142, 186, 85, 171, 71, 98, 76, 215, 47, 203, 75, 11, 32, 193, 10, 37, 197, 185, 137, 2, 122, 36, 17, 147, 217, 156, 156, 88, 166, 119, 4, 131, 60, 159, 234, 79, 255, 160, 144, 96, 161, 198, 144, 6, 247, 74, 76, 207, 50, 26, 243, 102, 68, 224, 179, 229, 3, 245, 204, 113, 50, 73, 71, 73, 95, 3, 242, 168, 43, 184, 71, 71, 215, 208, 0, 165])))]
Transaction Kind : Programmable
Inputs: [Pure(SuiPureValue { value_type: Some(Address), value: "0x8833b9cff8032ddf6eb52dd5fe82d9708f53f0d2a89d7ba5e94ba01fcca3c7dc" }), Object(ImmOrOwnedObject { object_id: 0x9d51acc8e1680392a6b46f1ca1f205ff4aa5557ee5564460283dc46a17a15c04, version: SequenceNumber(76), digest: o#7NMyHgKSKgSxyN2Ff4zPvsjpH443ja3JQ6s68dirMjm })]
Commands: [
TransferObjects([Input(1)],Input(0)),
]

Sender: 0x7e86320466e04f808a5e046a65d1458b3a28def339ea9986e5874496ef66bd08
Gas Payment: Object ID: 0x67e786d94eac270580eca1a5364b55efa59586ba6776e560bbae078ef82e5d8b, version: 0x52, digest: rxFR7PQ2Bd66ZD1G9K48rWCxY8VRFUBxaCSZ4bFN8fY
Gas Owner: 0x7e86320466e04f808a5e046a65d1458b3a28def339ea9986e5874496ef66bd08
Gas Price: 1000
Gas Budget: 10000000

----- Transaction Effects ----
Status : Success
Mutated Objects:

- ID: 0x67e786d94eac270580eca1a5364b55efa59586ba6776e560bbae078ef82e5d8b , Owner: Account Address ( 0x7e86320466e04f808a5e046a65d1458b3a28def339ea9986e5874496ef66bd08 )
- ID: 0x9d51acc8e1680392a6b46f1ca1f205ff4aa5557ee5564460283dc46a17a15c04 , Owner: Account Address ( 0x8833b9cff8032ddf6eb52dd5fe82d9708f53f0d2a89d7ba5e94ba01fcca3c7dc )

----- Events ----
Array []
----- Object changes ----
Array [
Object {
"type": String("mutated"),
"sender": String("0x7e86320466e04f808a5e046a65d1458b3a28def339ea9986e5874496ef66bd08"),
"owner": Object {
"AddressOwner": String("0x7e86320466e04f808a5e046a65d1458b3a28def339ea9986e5874496ef66bd08"),
},
"objectType": String("0x2::coin::Coin<0x2::sui::SUI>"),
"objectId": String("0x67e786d94eac270580eca1a5364b55efa59586ba6776e560bbae078ef82e5d8b"),
"version": String("83"),
"previousVersion": String("82"),
"digest": String("2v1HBdM5WnpTeVoEduA5Ntvi8AfNuCeMxdkyuiRugdnV"),
},
Object {
"type": String("mutated"),
"sender": String("0x7e86320466e04f808a5e046a65d1458b3a28def339ea9986e5874496ef66bd08"),
"owner": Object {
"AddressOwner": String("0x8833b9cff8032ddf6eb52dd5fe82d9708f53f0d2a89d7ba5e94ba01fcca3c7dc"),
},
"objectType": String("0x2::coin::Coin<0x2::sui::SUI>"),
"objectId": String("0x9d51acc8e1680392a6b46f1ca1f205ff4aa5557ee5564460283dc46a17a15c04"),
"version": String("83"),
"previousVersion": String("76"),
"digest": String("FtMxcqAE2S9Ss6nQjkvXVACCfjSFsVM51mWDErBow5ta"),
},
]
----- Balance changes ----
Array [
Object {
"owner": Object {
"AddressOwner": String("0x7e86320466e04f808a5e046a65d1458b3a28def339ea9986e5874496ef66bd08"),
},
"coinType": String("0x2::sui::SUI"),
"amount": String("-10001019760"),
},
Object {
"owner": Object {
"AddressOwner": String("0x8833b9cff8032ddf6eb52dd5fe82d9708f53f0d2a89d7ba5e94ba01fcca3c7dc"),
},
"coinType": String("0x2::sui::SUI"),
"amount": String("10000000000"),
},
]

========
❯ sui client objects
Object ID | Version | Digest | Owner Type | Object Type

---

0x67e786d94eac270580eca1a5364b55efa59586ba6776e560bbae078ef82e5d8b | 83 | HG/JCT/ZRkI6+9zw5u8mxnK3+5lqLrfToCynZj22bfY= | AddressOwner | Some(Struct(MoveObjectType(GasCoin)))
Showing 1 results.
```

</details>

- Call a module function with arguments

The function looks like this:

```move
    public entry fun update_hello_object(hello: &mut Hello, message: String, timestamp: u32, _new_owner: address, _ctx: &mut TxContext) {
            hello.message = message;
            hello.timestamp = timestamp;
            // transfer::transfer(hello, new_owner);
    }
```

<details>
<summary><b>Details:</b></summary>
❯ sui client call --function update_hello_object --module hello --package 0x5a9f0ce98f908966ec1d3cd4437a83e85b40681f2677842c863d1500e7af65f2 --args 0x4e6c7e7c35b9686ac2865637eaed781c7cfa30f26e71445dab063fffe4de57ca "Good morning" 12342543 0x8833b9cff8032ddf6eb52dd5fe82d9708f53f0d2a89d7ba5e94ba01fcca3c7dc --gas-budget 10000000
----- Transaction Digest ----
HQmZAfzcFBpLkKCKZurwE8WpzfJSG9eDjCkUPua4Uyyt
----- Transaction Data ----
Transaction Signature: [Signature(Ed25519SuiSignature(Ed25519SuiSignature([0, 127, 189, 111, 213, 244, 122, 129, 118, 127, 143, 40, 191, 230, 213, 102, 103, 33, 253, 136, 85, 253, 137, 97, 234, 207, 16, 254, 75, 52, 146, 196, 229, 77, 151, 86, 114, 83, 84, 60, 20, 140, 40, 232, 189, 192, 224, 30, 179, 174, 89, 213, 40, 250, 56, 54, 221, 17, 13, 228, 70, 202, 81, 41, 14, 247, 74, 76, 207, 50, 26, 243, 102, 68, 224, 179, 229, 3, 245, 204, 113, 50, 73, 71, 73, 95, 3, 242, 168, 43, 184, 71, 71, 215, 208, 0, 165])))]
Transaction Kind : Programmable
Inputs: [Object(ImmOrOwnedObject { object_id: 0x4e6c7e7c35b9686ac2865637eaed781c7cfa30f26e71445dab063fffe4de57ca, version: SequenceNumber(95), digest: o#6NBwDh1k23YiuvtYN5Mmjf7mdLxecBBviTwcnGrfVRhV }), Pure(SuiPureValue { value_type: Some(Struct(StructTag { address: 0000000000000000000000000000000000000000000000000000000000000001, module: Identifier("string"), name: Identifier("String"), type_params: [] })), value: "Good morning" }), Pure(SuiPureValue { value_type: Some(U32), value: 12342543 }), Pure(SuiPureValue { value_type: Some(Address), value: "0x8833b9cff8032ddf6eb52dd5fe82d9708f53f0d2a89d7ba5e94ba01fcca3c7dc" })]
Commands: [
  MoveCall(0x5a9f0ce98f908966ec1d3cd4437a83e85b40681f2677842c863d1500e7af65f2::hello::update_hello_object(Input(0),Input(1),Input(2),Input(3))),
]

Sender: 0x7e86320466e04f808a5e046a65d1458b3a28def339ea9986e5874496ef66bd08
Gas Payment: Object ID: 0x67e786d94eac270580eca1a5364b55efa59586ba6776e560bbae078ef82e5d8b, version: 0x5f, digest: LBCjNb4SJrzibGnEd6D1R386ZhbFgPiCcCEz4VAUgeg
Gas Owner: 0x7e86320466e04f808a5e046a65d1458b3a28def339ea9986e5874496ef66bd08
Gas Price: 1000
Gas Budget: 10000000

----- Transaction Effects ----
Status : Success
Mutated Objects:

- ID: 0x4e6c7e7c35b9686ac2865637eaed781c7cfa30f26e71445dab063fffe4de57ca , Owner: Account Address ( 0x7e86320466e04f808a5e046a65d1458b3a28def339ea9986e5874496ef66bd08 )
- ID: 0x67e786d94eac270580eca1a5364b55efa59586ba6776e560bbae078ef82e5d8b , Owner: Account Address ( 0x7e86320466e04f808a5e046a65d1458b3a28def339ea9986e5874496ef66bd08 )

----- Events ----
Array []
----- Object changes ----
Array [
Object {
"type": String("mutated"),
"sender": String("0x7e86320466e04f808a5e046a65d1458b3a28def339ea9986e5874496ef66bd08"),
"owner": Object {
"AddressOwner": String("0x7e86320466e04f808a5e046a65d1458b3a28def339ea9986e5874496ef66bd08"),
},
"objectType": String("0x5a9f0ce98f908966ec1d3cd4437a83e85b40681f2677842c863d1500e7af65f2::hello::Hello"),
"objectId": String("0x4e6c7e7c35b9686ac2865637eaed781c7cfa30f26e71445dab063fffe4de57ca"),
"version": String("96"),
"previousVersion": String("95"),
"digest": String("5xpgt6pMa43fSBMoCPAKzsh44REwUoixxCed8VsPQEFs"),
},
Object {
"type": String("mutated"),
"sender": String("0x7e86320466e04f808a5e046a65d1458b3a28def339ea9986e5874496ef66bd08"),
"owner": Object {
"AddressOwner": String("0x7e86320466e04f808a5e046a65d1458b3a28def339ea9986e5874496ef66bd08"),
},
"objectType": String("0x2::coin::Coin<0x2::sui::SUI>"),
"objectId": String("0x67e786d94eac270580eca1a5364b55efa59586ba6776e560bbae078ef82e5d8b"),
"version": String("96"),
"previousVersion": String("95"),
"digest": String("7AcurZ1You22rtXMbDT7yo9XGS165vecAkSrmdmwncdP"),
},
]
----- Balance changes ----
Array [
Object {
"owner": Object {
"AddressOwner": String("0x7e86320466e04f808a5e046a65d1458b3a28def339ea9986e5874496ef66bd08"),
},
"coinType": String("0x2::sui::SUI"),
"amount": String("-1023864"),
},
]

</details>
