# NFT

A minimal ERC-721 token written from scratch in Solidity, with no OpenZeppelin or other base contracts. Built with [Foundry](https://getfoundry.sh/).

## Features

- Implements the [ERC-721](https://eips.ethereum.org/EIPS/eip-721) core interface: balances, ownership, transfers, per-token approvals and operators
- [ERC-165](https://eips.ethereum.org/EIPS/eip-165) interface detection (`supportsInterface`)
- Safe transfers and safe mints: tokens sent to a contract are rejected unless it implements `onERC721Received`
- Open minting: anyone can call `mint()` to receive the next token ID, starting from `0`

Not implemented: the optional Metadata (`name`, `symbol`, `tokenURI`) and Enumerable extensions, and burning.

## Project layout

```
src/
├── NFT.sol                  # The token contract
├── ERC721.sol               # ERC-721 interface
├── ERC165.sol               # ERC-165 interface
└── ERC721TokenReceiver.sol  # Receiver interface for safe transfers
```

## Contract API

| Function | Description |
|---|---|
| `mint()` | Mints the next token to `msg.sender` |
| `balanceOf(owner)` | Number of tokens owned; reverts for the zero address |
| `ownerOf(tokenId)` | Owner of a token; reverts if it doesn't exist |
| `transferFrom(from, to, tokenId)` | Transfers a token; caller must be the owner, approved address or operator |
| `safeTransferFrom(from, to, tokenId[, data])` | Like `transferFrom`, but checks that a contract recipient accepts the token |
| `approve(approved, tokenId)` | Sets the approved address for one token |
| `setApprovalForAll(operator, approved)` | Grants or revokes an operator for all of the caller's tokens |
| `getApproved(tokenId)` | Approved address for a token |
| `isApprovedForAll(owner, operator)` | Whether `operator` manages all of `owner`'s tokens |
| `supportsInterface(interfaceId)` | `true` for ERC-165 and ERC-721 |

## Getting started

Requires [Foundry](https://getfoundry.sh/introduction/installation/).

```shell
git clone --recursive <repo-url>
cd NFT
forge build
```

If you cloned without `--recursive`, fetch the dependencies with `git submodule update --init --recursive`.

### Test

```shell
forge test
```

### Format

```shell
forge fmt
```

## Deploy

Run a local node:

```shell
anvil
```

Deploy to it using one of Anvil's prefunded accounts, or to any network by changing `--rpc-url`:

```shell
forge create src/NFT.sol:NFT --rpc-url <rpc_url> --account <keystore_account> --broadcast
```

Import a key into an encrypted keystore with `cast wallet import <name> --interactive` rather than passing `--private-key` on the command line.

### Interact with `cast`

```shell
cast send <nft_address> "mint()" --rpc-url <rpc_url> --account <keystore_account>
cast call <nft_address> "ownerOf(uint256)(address)" 0 --rpc-url <rpc_url>
```

## License

MIT
