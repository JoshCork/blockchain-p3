pragma solidity ^0.4.24;

// Import the access control libraries
import "../coffeeaccesscontrol/RetailerRole.sol";
import "../coffeeaccesscontrol/DistributorRole.sol";
import "../coffeeaccesscontrol/FarmerRole.sol";
import "../coffeeaccesscontrol/ConsumerRole.sol";

// Impor../coffeeaccesscontrol
import "../coffeecore/Ownable.sol";


// Define a contract 'Supplychain'
contract SupplyChain is Ownable, ConsumerRole, DistributorRole, FarmerRole, RetailerRole {

  // Define 'itemOwner'
  address itemOwner;

  // Define a variable called 'upc' for Universal Product Code (UPC)
  uint  upc;

  // Define a variable called 'sku' for Stock Keeping Unit (SKU)
  uint  sku;

  // Define a public mapping 'items' that maps the UPC to an Item.
  mapping (uint => Item) items;

  // Define a public mapping 'itemsHistory' that maps the UPC to an array of TxHash,
  // that track its journey through the supply chain -- to be sent from DApp.
  mapping (uint => string[]) itemsHistory;

  // Define enum 'State' with the following values:
  enum State
  {
    Harvested,  // 0
    Processed,  // 1
    Packed,     // 2
    ForSale,    // 3
    Sold,       // 4
    Shipped,    // 5
    Received,   // 6
    Purchased   // 7
    }

  State constant defaultState = State.Harvested;

  // Define a struct 'Item' with the following fields:
  struct Item {
    uint    sku;  // Stock Keeping Unit (SKU)
    uint    upc; // Universal Product Code (UPC), generated by the Farmer, goes on the package, can be verified by the Consumer
    address itemOwnerID;  // Metamask-Ethereum address of the current itemOwner as the product moves through 8 stages
    address originFarmerID; // Metamask-Ethereum address of the Farmer
    string  originFarmName; // Farmer Name
    string  originFarmInformation;  // Farmer Information
    string  originFarmLatitude; // Farm Latitude
    string  originFarmLongitude;  // Farm Longitude
    uint    productID;  // Product ID potentially a combination of upc + sku
    string  productNotes; // Product Notes
    uint    productPrice; // Product Price
    State   itemState;  // Product State as represented in the enum above
    address distributorID;  // Metamask-Ethereum address of the Distributor
    address retailerID; // Metamask-Ethereum address of the Retailer
    address consumerID; // Metamask-Ethereum address of the Consumer
  }

  // Define 8 events with the same 8 state values and accept 'upc' as input argument
  event Harvested(uint upc);
  event Processed(uint upc);
  event Packed(uint upc);
  event ForSale(uint upc);
  event Sold(uint upc);
  event Shipped(uint upc);
  event Received(uint upc);
  event Purchased(uint upc);

  // Define a modifer that checks to see if msg.sender == itemOwner of the contract
  modifier onlyItemOwner() {
    require(msg.sender == itemOwner,"not the itemOwner");
    _;
  }

  // Define a modifer that verifies the Caller
  modifier verifyCaller (address _address) {
    require(msg.sender == _address, "Cannot verify caller");
    _;
  }

  // Define a modifier that checks if the paid amount is sufficient to cover the price
  modifier paidEnough(uint _upc) {
    uint _price = items[_upc].productPrice;
    require(msg.value >= _price,"have not paid enough ");
    _;
  }
  // Define a modifier that checks the price and refunds the remaining balance
  modifier returnChange(uint _upc) {
    uint _price = items[_upc].productPrice;
    uint amountToReturn = msg.value - _price;
    msg.sender.transfer(amountToReturn);
    require(msg.value >= _price,"Issue returning change.");
    _;
  }

  // Define a modifier that checks if an item.state of a upc is Harvested
  modifier harvested(uint _upc) {
    require(items[_upc].itemState == State.Harvested);
    _;
  }

  // Define a modifier that checks if an item.state of a upc is Processed
  modifier processed(uint _upc) {
    require(items[_upc].itemState == State.Processed);
    _;
  }

  // Define a modifier that checks if an item.state of a upc is Packed
  modifier packed(uint _upc) {
  require(items[_upc].itemState == State.Packed);
    _;
  }

  // Define a modifier that checks if an item.state of a upc is ForSale
  modifier forSale(uint _upc) {
    require(items[_upc].itemState == State.ForSale);
    _;
  }

  // Define a modifier that checks if an item.state of a upc is Sold
  modifier sold(uint _upc) {
    require(items[_upc].itemState == State.Sold);
    _;
  }

  // Define a modifier that checks if an item.state of a upc is Shipped
  modifier shipped(uint _upc) {
    require(items[_upc].itemState == State.Shipped);
    _;
  }

  // Define a modifier that checks if an item.state of a upc is Received
  modifier received(uint _upc) {
    require(items[_upc].itemState == State.Received);
    _;
  }

  // Define a modifier that checks if an item.state of a upc is Purchased
  modifier purchased(uint _upc) {
    require(items[_upc].itemState == State.Purchased);
    _;
  }

  // In the constructor set 'owner' to the address that instantiated the contract
  // and set 'sku' to 1
  // and set 'upc' to 1
  constructor() public payable {
    // owner = msg.sender; // commented out now that it inherits owner from Ownable
    sku = 1;
    upc = 1;
  }

  // Define a function 'kill' if required

  /*
    Commented out per the reviewer's recommendation.
    You can also delete the selfdestruct function to avoid implicit address payable conversion errors.
    This is not critical to the project.
    You can reintroduce and make all conversions later when you've completed the requirement.
  */
  // function kill() public {
  //   if (msg.sender == owner) {
  //     selfdestruct(owner);
  //   }
  // }

  // Define a function 'harvestItem' that allows a farmer to mark an item 'Harvested'
  function harvestItem(
                        uint _upc,
                        uint _productID,
                        address _originFarmerID,
                        string _originFarmName,
                        string _originFarmInformation,
                        string  _originFarmLatitude,
                        string  _originFarmLongitude,
                        string  _productNotes) public
  onlyFarmer()
  {
    // Add the new item as part of Harvest
    Item memory harvestedItem;
    harvestedItem.upc = _upc;
    harvestedItem.sku = sku;
    harvestedItem.productID = _productID;
    harvestedItem.itemOwnerID = _originFarmerID;
    harvestedItem.originFarmerID = _originFarmerID;
    harvestedItem.originFarmName = _originFarmName;
    harvestedItem.originFarmInformation = _originFarmInformation;
    harvestedItem.originFarmLatitude = _originFarmLatitude;
    harvestedItem.originFarmLongitude = _originFarmLongitude;
    harvestedItem.productNotes = _productNotes;

    items[_upc] = harvestedItem;
    addFarmer(_originFarmerID);

    // Increment sku
    sku = sku + 1;
    // Emit the appropriate event
    emit Harvested(_upc);
  }

  // Define a function 'processtItem' that allows a farmer to mark an item 'Processed'
  function processItem(uint _upc) public
  harvested(_upc) // Call modifier to check if upc has passed previous supply chain stage
  onlyFarmer() // Modifier ensuring that only a farmer can process an Item
  verifyCaller(items[_upc].originFarmerID) // Modifier to make sure the original farmer is the only on e that can process the item

  {
    items[_upc].itemState = State.Processed; // Update the appropriate fields
    emit Processed(_upc); // Emit the appropriate event
  }

  // Define a function 'packItem' that allows a farmer to mark an item 'Packed'
  function packItem(uint _upc) public
  onlyFarmer() // Modifier ensuring that only a farmer can process an Item
  processed(_upc) // Call modifier to check if upc has passed previous supply chain stage
  verifyCaller(items[_upc].originFarmerID) // Modifier to make sure the original farmer is the only on e that can process the item

  {
    items[_upc].itemState = State.Packed; // Update the appropriate fields
    emit Packed(_upc); // Emit the appropriate event
  }

  // Define a function 'sellItem' that allows a farmer to mark an item 'ForSale'
  function sellItem(uint _upc, uint _price) public
  onlyFarmer()  // Modifier ensuring that only a farmer can process an Item
  packed(_upc) // Call modifier to check if upc has passed previous supply chain stage
  verifyCaller(items[_upc].originFarmerID) // Modifier to make sure the original farmer is the only on e that can process the item
  {
    // Update the appropriate fields
    items[_upc].itemState = State.ForSale;
    items[_upc].productPrice = _price;
    emit ForSale(_upc); // Emit the appropriate event
  }

  // Define a function 'buyItem' that allows the disributor to mark an item 'Sold'
  // Use the above defined modifiers to check if the item is available for sale,
  // if the buyer has paid enough,
  // and any excess ether sent is refunded back to the buyer
  function buyItem(uint _upc) public payable
    forSale(_upc) // Call modifier to check if upc has passed previous supply chain stage
    paidEnough(_upc) // Call modifer to check if buyer has paid enough
    returnChange(_upc) // Call modifer to send any excess ether back to buyer

    /*
    Who actually does the calling of buyItem?  I'm assuming that the distributor should do so
    but in order to use the onlyDistributor modifier I have to have that distributor added to
    a list of known distributors prior to envoking this function?
    */

    {

    // Update the appropriate fields - itemOwnerID, distributorID, itemState
    uint _wholesalePrice = items[_upc].productPrice ;
    uint _msrp = _wholesalePrice * 4;
    items[_upc].itemOwnerID = msg.sender;
    items[_upc].distributorID = msg.sender;
    items[_upc].itemState = State.Sold;
    // Transfer money to farmer
    // TODO: ask question about this.  It seems weird that change is returned before paying the farmer.
    // What if this is the farmer's first sale and he/she has no Ether in their wallet?
    // I assume then that this amount to return comes from the contract itself and the ether stored there
    // during the transaction itself.
    items[_upc].originFarmerID.transfer(_wholesalePrice);

    // markup the price for sale to the end consumer
    items[_upc].productPrice = _msrp;

    // emit the appropriate event
    emit Sold(_upc);
  }

  // Define a function 'shipItem' that allows the distributor to mark an item 'Shipped'
  // Use the above modifers to check if the item is sold
  function shipItem(uint _upc) public
    // Call modifier to check if upc has passed previous supply chain stage
    sold(_upc)
    // Call modifier to verify caller of this function
    verifyCaller(items[_upc].distributorID)
    {
    // Update the appropriate fields
    items[_upc].itemState = State.Shipped;
    // Emit the appropriate event
    emit Shipped(_upc);
  }

  // Define a function 'receiveItem' that allows the retailer to mark an item 'Received'
  // Use the above modifiers to check if the item is shipped
  function receiveItem(uint _upc) public
    // Call modifier to check if upc has passed previous supply chain stage
    shipped(_upc)
    // Access Control List enforced by calling Smart Contract / DApp
    // TODO: NOT SURE WHAT TO DO HERE --> I assume confirm that the person calling
    // this function is actually the retailer?
    {
    // Update the appropriate fields - itemOwnerID, retailerID, itemState
    // TODO: Does the distributor still own it once it hits the retailer? I assume so since
    // no money has exchanged hands.  The retailer is just displaying the product for the
    // distributor.  Once it sells a portion goes to the distributor?
    items[_upc].retailerID = msg.sender;
    items[_upc].itemState = State.Received;

    // Emit the appropriate event
    emit Received(_upc);
  }

  // Define a function 'purchaseItem' that allows the consumer to mark an item 'Purchased'
  // Use the above modifiers to check if the item is received
  function purchaseItem(uint _upc) public payable
    // Call modifier to check if upc has passed previous supply chain stage
    received(_upc)
    // Call modifer to check if buyer has paid enough
    paidEnough(_upc)
    // Call modifer to send any excess ether back to buyer
    returnChange(_upc)

    // Access Control List enforced by calling Smart Contract / DApp
    {
    // Update the appropriate fields - itemOwnerID, consumerID, itemState
    items[_upc].itemOwnerID = msg.sender;
    items[_upc].consumerID = msg.sender;
    items[_upc].itemState = State.Purchased;
    uint revenueSplit = items[_upc].productPrice / 2;


    // // transfer the money to the distributor and retailer
    // // TODO: remember how to multiply times decimals.  Using integers here because
    // // I don't remember and this is an unrealistic markup and profit split.
    items[_upc].retailerID.transfer(revenueSplit);
    items[_upc].distributorID.transfer(revenueSplit);

    // Emit the appropriate event
    emit Purchased(_upc);
  }

  // Define a function 'fetchItemBufferOne' that fetches the data
  function fetchItemBufferOne(uint _upc) public view returns
  (
  uint    itemSKU,
  uint    itemUPC,
  address itemOwnerID,
  address originFarmerID,
  string  originFarmName,
  string  originFarmInformation,
  string  originFarmLatitude,
  string  originFarmLongitude
  )
  {
  // Assign values to the 8 parameters
  itemSKU = items[_upc].sku;
  itemUPC = items[_upc].upc;
  itemOwnerID = items[_upc].itemOwnerID;
  originFarmerID = items[_upc].originFarmerID;
  originFarmName = items[_upc].originFarmName;
  originFarmInformation = items[_upc].originFarmInformation;
  originFarmLatitude = items[_upc].originFarmLatitude;
  originFarmLongitude = items[_upc].originFarmLongitude;

  return
  (
  itemSKU,
  itemUPC,
  itemOwnerID,
  originFarmerID,
  originFarmName,
  originFarmInformation,
  originFarmLatitude,
  originFarmLongitude
  );
  }

  // Define a function 'fetchItemBufferTwo' that fetches the data
  function fetchItemBufferTwo(uint _upc) public view returns
  (
  uint    itemSKU,
  uint    itemUPC,
  uint    productID,
  string  productNotes,
  uint    productPrice,
  State    itemState,
  address distributorID,
  address retailerID,
  address consumerID
  )
  {
    // Assign values to the 9 parameters
  itemSKU = items[_upc].sku;
  itemUPC = items[_upc].upc;
  productID = items[_upc].productID;
  productNotes = items[_upc].productNotes;
  productPrice = items[_upc].productPrice;
  itemState = items[_upc].itemState;
  distributorID = items[_upc].distributorID;
  retailerID = items[_upc].retailerID;
  consumerID = items[_upc].consumerID;
  return
  (
  itemSKU,
  itemUPC,
  productID,
  productNotes,
  productPrice,
  itemState,
  distributorID,
  retailerID,
  consumerID
  );
  }
}
