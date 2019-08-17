# PROJECT 3

This repo contains the work associated with project 3. The site can be built using `npm run dev` and is pointed at my contract hosted on Rinkeby. The site can be pulled up using `http://localhost:3000/`.

You can find the Migration results including the contract address below.

As far as the contract itself goes I've modified the base template to make the supply chain a bit more realistic. Specifically:

1. In this contract, once a distributor purchases the crop from the farmer he marks up the price to the "manufacturing suggested retail price".
1. The goods are then consigned to a retailer (while still being owned by the distributor) and once the retailer has confirmed that the product has been received it can be sold.
1. Once the consumer purchases the goods from the retailer the contract will automatically split the revenue 50/50 with the distributor and retailer.

## Testing

I added some additional tests to ensure that when a farmer was paid his total ether increated by the amount expected. Same for the Retailer/Distributor. All tests are passing and can be run by firing up the Gnache GUI (or alternately switching the config to use the CLI Ganache port) and running `truffle test`

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
   Replacing 'SupplyChain'
   -----------------------
   > transaction hash:    0xea4c28f64c5d046e65e6a2aad7aabb0d027e4ff4f69b4d7fb5466d1c84dc84cb
   > Blocks: 0            Seconds: 8
   > contract address:    0x784Ad8D950FA61db115e02D3B1e3c49e62d644d5
   > block number:        4925279
   > block timestamp:     1566009187
   > account:             0x90b727c60f559cDD0e1DFf8c097D8a90c23d2df5
   > balance:             2.032664831
   > gas used:            2421060
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.0242106 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.03971816 ETH
```

## Migration Results - All Others

```
Starting migrations...
======================
> Network name:    'rinkeby'
> Network id:      4
> Block gas limit: 0x6ab7d3


1_initial_migration.js
======================

   Replacing 'Migrations'
   ----------------------
   > transaction hash:    0xdae638cdbee3398ca0c2a317ce11355550c84c98baef8e0a99e818e39e456a54
   > Blocks: 1            Seconds: 16
   > contract address:    0xDBE2205518Bc6A7c9EBa747430869D4f74249984
   > block number:        4925273
   > block timestamp:     1566009097
   > account:             0x90b727c60f559cDD0e1DFf8c097D8a90c23d2df5
   > balance:             2.072803071
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

   Replacing 'FarmerRole'
   ----------------------
   > transaction hash:    0x1c2a1dff5d81f62fddfb222b0283df8201de30541633d0cbfa1add353277c41a
   > Blocks: 0            Seconds: 12
   > contract address:    0x29fB77489F453e7894A455E694C835561e144a26
   > block number:        4925275
   > block timestamp:     1566009127
   > account:             0x90b727c60f559cDD0e1DFf8c097D8a90c23d2df5
   > balance:             2.068506421
   > gas used:            387657
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00387657 ETH


   Replacing 'DistributorRole'
   ---------------------------
   > transaction hash:    0xb2d09db62f1e000944a875db7ac1e20b7ed52a14f81136c6d796793d2725ed9e
   > Blocks: 1            Seconds: 12
   > contract address:    0xC95D1559B1d4Ba4eB6F71b3c4f2441c36715e4Eb
   > block number:        4925276
   > block timestamp:     1566009142
   > account:             0x90b727c60f559cDD0e1DFf8c097D8a90c23d2df5
   > balance:             2.064629851
   > gas used:            387657
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00387657 ETH


   Replacing 'RetailerRole'
   ------------------------
   > transaction hash:    0xf51ef906843f31d045ab914a616126906a9fb6db470082ed500f0f179e3a9d2c
   > Blocks: 0            Seconds: 12
   > contract address:    0x7a94b62dB232428e72f8fEA6bb147763E80fbd68
   > block number:        4925277
   > block timestamp:     1566009157
   > account:             0x90b727c60f559cDD0e1DFf8c097D8a90c23d2df5
   > balance:             2.060752001
   > gas used:            387785
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00387785 ETH


   Replacing 'ConsumerRole'
   ------------------------
   > transaction hash:    0xc64da0154c842df59c0002a23017d9e414db909e12917ba54b2cff8d0c01aa1d
   > Blocks: 1            Seconds: 12
   > contract address:    0x14003B869272051734bdc107933A38CbCa404bd6
   > block number:        4925278
   > block timestamp:     1566009172
   > account:             0x90b727c60f559cDD0e1DFf8c097D8a90c23d2df5
   > balance:             2.056875431
   > gas used:            387657
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00387657 ETH


Summary
=======
> Total deployments:   6
> Final cost:          0.04249278 ETH
```