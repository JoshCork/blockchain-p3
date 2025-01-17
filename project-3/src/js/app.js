App = {
    web3Provider: null,
    contracts: {},
    emptyAddress: "0x0000000000000000000000000000000000000000",
    sku: 0,
    upc: 0,
    metamaskAccountID: "0x0000000000000000000000000000000000000000",
    ownerID: "0x0000000000000000000000000000000000000000",
    originFarmerID: "0x0000000000000000000000000000000000000000",
    originFarmName: null,
    originFarmInformation: null,
    originFarmLatitude: null,
    originFarmLongitude: null,
    productNotes: null,
    productPrice: 0,
    distributorID: "0x0000000000000000000000000000000000000000",
    retailerID: "0x0000000000000000000000000000000000000000",
    consumerID: "0x0000000000000000000000000000000000000000",

    init: async function () {
        App.readForm();
        /// Setup access to blockchain
        return await App.initWeb3();
    },

    readForm: function () {
        App.sku = $("#sku").val(); // bufferOne[0]
        App.upc = $("#upc").val(); // bufferOne[1]
        App.ownerID = $("#ownerID").val(); // bufferOne[2]
        App.originFarmerID = $("#originFarmerID").val(); // bufferOne[3]
        App.originFarmName = $("#originFarmName").val(); // bufferOne[4]
        App.originFarmInformation = $("#originFarmInformation").val(); // bufferOne[5]
        App.originFarmLatitude = $("#originFarmLatitude").val(); // bufferOne[6]
        App.originFarmLongitude = $("#originFarmLongitude").val(); // bufferOne[7]
        App.productNotes = $("#productNotes").val(); // bufferTwo[3]
        App.productPrice = web3.toWei($('#productPrice').val(), "ether"); // bufferTwo[4]
        App.distributorID = $("#distributorID").val(); // bufferTwo[6]
        App.retailerID = $("#retailerID").val(); // bufferTwo[7]
        App.consumerID = $("#consumerID").val(); // bufferTwo[8]

        console.log(
            App.sku,
            App.upc,
            App.ownerID,
            App.originFarmerID,
            App.originFarmName,
            App.originFarmInformation,
            App.originFarmLatitude,
            App.originFarmLongitude,
            App.productNotes,
            App.productPrice,
            App.distributorID,
            App.retailerID,
            App.consumerID
        );
    },

    initWeb3: async function () {
        /// Find or Inject Web3 Provider
        /// Modern dapp browsers...
        if (window.ethereum) {
            App.web3Provider = window.ethereum;
            try {
                // Request account access
                await window.ethereum.enable();
            } catch (error) {
                // User denied account access...
                console.error("User denied account access")
            }
        }
        // Legacy dapp browsers...
        else if (window.web3) {
            App.web3Provider = window.web3.currentProvider;
        }
        // If no injected web3 instance is detected, fall back to Ganache
        else {
            App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
        }

        App.getMetaskAccountID();

        return App.initSupplyChain();
    },

    getMetaskAccountID: function () {
        web3 = new Web3(App.web3Provider);

        // Retrieving accounts
        web3.eth.getAccounts(function (err, res) {
            if (err) {
                console.log('Error:', err);
                return;
            }
            console.log('getMetaskID:', res);
            App.metamaskAccountID = res[0];

        })
    },

    initSupplyChain: function () {
        /// Source the truffle compiled smart contracts
        var jsonSupplyChain = '../../build/contracts/SupplyChain.json';

        /// JSONfy the smart contracts
        $.getJSON(jsonSupplyChain, function (data) {
            console.log('data', data);
            var SupplyChainArtifact = data;
            App.contracts.SupplyChain = TruffleContract(SupplyChainArtifact);
            App.contracts.SupplyChain.setProvider(App.web3Provider);

            App.fetchItemBufferOne();
            App.fetchItemBufferTwo();
            App.fetchEvents();

        });

        return App.bindEvents();
    },

    bindEvents: function () {
        $(document).on('click', App.handleButtonClick);
    },

    handleButtonClick: async function (event) {
        event.preventDefault();

        App.getMetaskAccountID();

        var processId = parseInt($(event.target).data('id'));
        console.log('processId', processId);

        switch (processId) {
            case 1:
                return await App.harvestItem(event);
                break;
            case 2:
                return await App.processItem(event);
                break;
            case 3:
                return await App.packItem(event);
                break;
            case 4:
                return await App.sellItem(event);
                break;
            case 5:
                return await App.buyItem(event);
                break;
            case 6:
                return await App.shipItem(event);
                break;
            case 7:
                return await App.receiveItem(event);
                break;
            case 8:
                return await App.purchaseItem(event);
                break;
            case 9:
                return await App.fetchItemBufferOne(event);
                break;
            case 10:
                console.log("hello there.");
                return await App.fetchItemBufferTwo(event);
                break;
        }
    },

    harvestItem: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        App.readForm(); // Take any changes that were made.
        App.contracts.SupplyChain.deployed().then(function (instance) {
            return instance.harvestItem(
                App.upc,
                App.metamaskAccountID,
                App.originFarmerID,
                App.originFarmName,
                App.originFarmInformation,
                App.originFarmLatitude,
                App.originFarmLongitude,
                App.productNotes
                // very cool.
            );
        }).then(function (result) {
            $("#ftc-item").text(result);
            console.log('harvestItem', result);
        }).catch(function (err) {
            console.log(err.message);
        });
    },

    processItem: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        App.readForm(); // Take any changes that were made.

        App.contracts.SupplyChain.deployed().then(function (instance) {
            return instance.processItem(App.upc, {
                from: App.metamaskAccountID
            });
        }).then(function (result) {
            $("#ftc-item").text(result);
            console.log('processItem', result);
        }).catch(function (err) {
            console.log(err.message);
        });
    },

    packItem: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        App.readForm(); // Take any changes that were made.

        App.contracts.SupplyChain.deployed().then(function (instance) {
            return instance.packItem(App.upc, {
                from: App.metamaskAccountID
            });
        }).then(function (result) {
            $("#ftc-item").text(result);
            console.log('packItem', result);
        }).catch(function (err) {
            console.log(err.message);
        });
    },

    sellItem: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        App.readForm(); // Take any changes that were made.

        App.contracts.SupplyChain.deployed().then(function (instance) {

            // const productPrice = web3.toWei($('#productPrice').val(), "ether");
            console.log('productPrice', App.productPrice);
            return instance.sellItem(App.upc, App.productPrice, {
                from: App.metamaskAccountID
            });
        }).then(function (result) {
            $("#ftc-item").text(result);
            console.log('sellItem', result);
        }).catch(function (err) {
            console.log(err.message);
        });
    },

    buyItem: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        App.readForm(); // Take any changes that were made.

        App.contracts.SupplyChain.deployed().then(function (instance) {
            const walletValue = web3.toWei(3, "ether");
            return instance.buyItem(App.upc, {
                from: App.metamaskAccountID,
                value: walletValue
            });
        }).then(function (result) {
            $("#ftc-item").text(result);
            console.log('buyItem', result);
        }).catch(function (err) {
            console.log(err.message);
        });
    },

    shipItem: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        App.readForm(); // Take any changes that were made.

        App.contracts.SupplyChain.deployed().then(function (instance) {
            return instance.shipItem(App.upc, {
                from: App.metamaskAccountID
            });
        }).then(function (result) {
            $("#ftc-item").text(result);
            console.log('shipItem', result);
        }).catch(function (err) {
            console.log(err.message);
        });
    },

    receiveItem: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        App.readForm(); // Take any changes that were made.

        App.contracts.SupplyChain.deployed().then(function (instance) {
            return instance.receiveItem(App.upc, {
                from: App.metamaskAccountID
            });
        }).then(function (result) {
            $("#ftc-item").text(result);
            console.log('receiveItem', result);
        }).catch(function (err) {
            console.log(err.message);
        });
    },

    purchaseItem: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        App.readForm(); // Take any changes that were made.

        App.contracts.SupplyChain.deployed().then(function (instance) {
            const walletValue = web3.toWei(5.1, "ether");
            console.log(walletValue);
            console.log(`MetamaskID: ${App.metamaskAccountID}`);
            console.log(`App UPC: ${App.upc}`)
            return instance.purchaseItem(App.upc,{value: walletValue});
        }).then(function (result) {
            $("#ftc-item").text(result);
            console.log('purchaseItem', result);
        }).catch(function (err) {
            console.log(err.message);
        });
    },

    fetchItemBufferOne: function () {
        // sku:  bufferOne[0]
        // upc:  bufferOne[1]
        // ownerID:  bufferOne[2]
        // originFarmerID:  bufferOne[3]
        // originFarmName:  bufferOne[4]
        // originFarmInformation:  bufferOne[5]
        // originFarmLatitude:  bufferOne[6]
        // originFarmLongitude:  bufferOne[7]
        // productNotes: bufferTwo[3]
        // productPrice:  bufferTwo[4]
        // distributorID:  bufferTwo[6]
        // retailerID:  bufferTwo[7]
        // consumerID:  bufferTwo[8]


        ///   event.preventDefault();
        ///    var processId = parseInt($(event.target).data('id'));
        App.upc = $('#upc').val();
        console.log('upc', App.upc);

        App.contracts.SupplyChain.deployed().then(function (instance) {
            return instance.fetchItemBufferOne(App.upc);
        }).then(function (result) {

            console.log(`sku: ${result[0]}`);
            console.log(`upc: ${result[1]}`);
            console.log(`ownerID: ${result[2]}`);
            console.log(`originFarmerID: ${result[3]}`);
            console.log(`originFarmName: ${result[4]}`);
            console.log(`originFarmInformation: ${result[5]}`);
            console.log(`originFarmLatitude: ${result[6]}`);
            console.log(`originFarmLongitud: ${result[7]}`);

            $("#sku").val(result[0]);
            $("#upc").val(result[1]);
            $("#ownerID").val(result[2]);
            $("#originFarmerID").val(result[3]);
            $("#originFarmName").val(result[4]);
            $("#originFarmInformation").val(result[5]);
            $("#originFarmLatitude").val(result[6]);
            $("#originFarmLongitude").val(result[7]);
        }).catch(function (err) {
            console.log(err.message);
        });
    },

    fetchItemBufferTwo: function () {
        ///    event.preventDefault();
        ///    var processId = parseInt($(event.target).data('id'));

        App.upc = $('#upc').val();
        console.log('upc', App.upc);

        App.contracts.SupplyChain.deployed().then(function (instance) {
            return instance.fetchItemBufferTwo.call(App.upc);
        }).then(function (result) {
            $("#ftc-item").text(result);

            console.log(`itemState: ${result[5]}`);
            console.log(`productPrice:  ${result[4]}`);
            console.log(`distributorID:  ${result[6]}`);
            console.log(`retailerID:  ${result[7]}`);
            console.log(`consumerID:  ${result[8]}`);

            $("#productNotes").val(result[3]);
            $("#productPrice").val(web3.fromWei(result[4], "ether"));
            $("#distributorID").val(result[6]);
            $("#retailerID").val(result[7]);
            $("#consumerID").val(result[8]);

            console.log('fetchItemBufferTwo', result);
        }).catch(function (err) {
            console.log(err.message);
        });
    },

    fetchEvents: function () {
        if (typeof App.contracts.SupplyChain.currentProvider.sendAsync !== "function") {
            App.contracts.SupplyChain.currentProvider.sendAsync = function () {
                return App.contracts.SupplyChain.currentProvider.send.apply(
                    App.contracts.SupplyChain.currentProvider,
                    arguments
                );
            };
        }

        App.contracts.SupplyChain.deployed().then(function (instance) {
            var events = instance.allEvents(function (err, log) {
                if (!err)
                    $("#ftc-events").append('<li>' + log.event + ' - ' + log.transactionHash + '</li>');
            });
        }).catch(function (err) {
            console.log(err.message);
        });

    }
};

$(function () {
    $(window).load(function () {
        App.init();
    });
});