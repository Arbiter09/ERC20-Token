# 🏆 Foundry ERC20 Token

This is a simple ERC20 token implementation using Solidity and OpenZeppelin's ERC20 library. The project is built using [Foundry](https://github.com/foundry-rs/foundry), a fast and efficient development framework for Ethereum smart contracts.

---

## 📌 Features

- ✅ Implements ERC20 token standard using OpenZeppelin.
- ✅ Unit tests written in Solidity using Foundry's `forge` framework.
- ✅ Automated deployment script with Foundry.
- ✅ Includes transfer, allowance, and revert condition tests.

---

## 🛠️ Installation

### Prerequisites

Ensure you have the following installed:

- [Foundry](https://book.getfoundry.sh/getting-started/installation) (For smart contract development)
- [Git](https://git-scm.com/) (To clone the repository)
- [Node.js](https://nodejs.org/) (Optional, for additional blockchain development tools)

### Clone the Repository

```sh
git clone https://github.com/Arbiter09/ERC20-Token.git
cd ERC20-Token
```

### Install Foundry Dependencies

```sh
forge install
```

---

## 📜 Smart Contracts

### **`OurToken.sol`**

This is the ERC20 token contract.

```solidity
contract OurToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("OurToken", "OT") {
        _mint(msg.sender, initialSupply);
    }
}
```

- The contract inherits from OpenZeppelin's `ERC20`.
- The constructor mints the initial supply to the deployer.

### **`DeployOurToken.s.sol`**

A Foundry deployment script to deploy the ERC20 token.

```solidity
contract DeployOurToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns (OurToken) {
        vm.startBroadcast();
        OurToken ot = new OurToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return ot;
    }
}
```

---

## 🧪 Running Tests

### Run All Tests

```sh
forge test
```

### Run a Specific Test

```sh
forge test --mt testSuccessfulTransfer
```

### Enable Verbose Output

```sh
forge test -vvvv
```

---

## 🚀 Deploying to a Local Blockchain

To deploy to a local Ethereum network:

1. Start a local node with [Anvil](https://book.getfoundry.sh/anvil/)
   ```sh
   anvil
   ```
2. Deploy using Foundry:
   ```sh
   forge script script/DeployOurToken.s.sol:DeployOurToken --fork-url http://localhost:8545 --broadcast
   ```

To deploy on a testnet (e.g., Sepolia):

```sh
forge script script/DeployOurToken.s.sol:DeployOurToken --rpc-url <YOUR_RPC_URL> --private-key <YOUR_PRIVATE_KEY> --broadcast
```

---

## 📜 License

This project is licensed under the **MIT License**.

---

---

Happy coding! 🚀
