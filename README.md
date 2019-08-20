# PROJECT 3

This repo contains the work associated with project 3. All the code, contracts, and truffle migration stuff is in the project-3 folder.

### Running the project locally

1. Open terminal and navigate into the project-3 folder
1. Install dependencies by navigating by running `npm install`
1. Start the Ganache UI or modifiy the truffle config file to use the Ganache CLI
1. Compile the contracts using `truffle compile` (see notes below about .secret)
1. Migrate the contracts using `truffle migrate`
1. Run the command `npm run dev`
1. The site will be pulled up using `http://localhost:3000/`

### Using Truffle to test/migrate

You'll need to create a `.secret` file with your own Mnemonic to connect it locally to Gnache or deploy a copy of it using your own Rinkeby account.

## General Information

You can find the Rinkeby Migration results including the contract address below.

As far as the contract itself goes I've modified the base template to make the supply chain a bit more realistic. Specifically:

1. In this contract, once a distributor purchases the crop from the farmer he marks up the price to the "manufacturing suggested retail price".
1. The goods are then consigned to a retailer (while still being owned by the distributor) and once the retailer has confirmed that the product has been received it can be sold.
1. Once the consumer purchases the goods from the retailer the contract will automatically split the revenue 50/50 with the distributor and retailer.

## Testing

I added some additional tests to ensure that when a farmer was paid his total ether increated by the amount expected. Same for the Retailer/Distributor. All tests are passing and can be run by firing up the Gnache GUI (or alternately switching the config to use the CLI Ganache port) and running `truffle test`
Testing with the UI connected to Rinkeby.  I've not implemented any UI to allow the user to add addresses to different roles.  Instead you should use the account that the contract is deployed with (the owner of the contract).  By default that account is added to all roles. You'll want to copy and paste that address into the owner and farmer text boses on the UI becasuse that information is sent back into the contract to set up the inital owner of the item and farmer that is harvesting the item.

## UML

All the UML from the exercises that I did for my business as well as the pre-project UML for the coffee shop can be found in the project-3/uml folder.

## Libraries

I didn't pull in any additional libraries for use in the project. In the development of the project, I did have to add the following two libraries to make my migrations with truffle work. This was the same as was instructed in the last project in the student forums. Specifically, I had to add:

* `"any-promise": "^1.3.0"`

* `"truffle-hdwallet-provider": "^1.0.0-web3one.5"`

## IPFS

I didn't use IPFS in this project as in my extensive work with IPFS during the coursework it seemed slow and unresponsive. I pointed my domain (joshuacork.com) at a template site hosted by IPFS with just the bare-bones minimum css, HTML, and javascript required to run the site and it still won't load.

## Product Images

I did not implement the two optional methods to store the product image in this submission.


## Migration Results - SupplyChain Contract

```
   Deploying 'SupplyChain'
   -----------------------
   > transaction hash:    0xf129025ecdb69fb79a377dba6677e07742d021f88793b700ad5d61905eb83be9
   > Blocks: 0            Seconds: 8
   > contract address:    0xAF21A648e66Bd4dA2a8E7117E5c046cD9a9237fB
   > block number:        4942904
   > block timestamp:     1566273580
   > account:             0x90b727c60f559cDD0e1DFf8c097D8a90c23d2df5
   > balance:             1.993958161
   > gas used:            3524189
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.03524189 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.03524189 ETH
```

## Migration Results - All Others

```
Compiling your contracts...
===========================
> Everything is up to date, there is nothing to compile.


Migrations dry-run (simulation)
===============================
> Network name:    'rinkeby-fork'
> Network id:      4
> Block gas limit: 0x6ab630


1_initial_migration.js
======================

   Deploying 'Migrations'
   ----------------------
   > block number:        4942901
   > block timestamp:     1566273519
   > account:             0x90b727c60f559cDD0e1DFf8c097D8a90c23d2df5
   > balance:             2.029770131
   > gas used:            262462
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00262462 ETH

   -------------------------------------
   > Total cost:          0.00262462 ETH


2_deploy_contracts.js
=====================

   Deploying 'SupplyChain'
   -----------------------
   > block number:        4942903
   > block timestamp:     1566273527
   > account:             0x90b727c60f559cDD0e1DFf8c097D8a90c23d2df5
   > balance:             1.995308161
   > gas used:            3419189
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.03419189 ETH

   -------------------------------------
   > Total cost:          0.03419189 ETH


Summary
=======
> Total deployments:   2
> Final cost:          0.03681651 ETH


Starting migrations...
======================
> Network name:    'rinkeby'
> Network id:      4
> Block gas limit: 0x6a9e75


1_initial_migration.js
======================

   Deploying 'Migrations'
   ----------------------
   > transaction hash:    0x9c2bcfb4c78986069dbba9f083dc5c86f3f2f9687ecaa74fd778befc78fbceb3
   > Blocks: 1            Seconds: 12
   > contract address:    0x4e1acEb1c0106E2a910eE87b8bbD2dd9987E282D
   > block number:        4942902
   > block timestamp:     1566273550
   > account:             0x90b727c60f559cDD0e1DFf8c097D8a90c23d2df5
   > balance:             2.029620131
   > gas used:            277462
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00277462 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.00277462 ETH


2_deploy_contracts.js
=====================

   Deploying 'SupplyChain'
   -----------------------
   > transaction hash:    0xf129025ecdb69fb79a377dba6677e07742d021f88793b700ad5d61905eb83be9
   > Blocks: 0            Seconds: 8
   > contract address:    0xAF21A648e66Bd4dA2a8E7117E5c046cD9a9237fB
   > block number:        4942904
   > block timestamp:     1566273580
   > account:             0x90b727c60f559cDD0e1DFf8c097D8a90c23d2df5
   > balance:             1.993958161
   > gas used:            3524189
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.03524189 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.03524189 ETH


Summary
=======
> Total deployments:   2
> Final cost:          0.03801651 ETH
```