//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
contract Project{
    struct Issuer{
        string DId;
        string Name;
        bytes32 Ukey;
        bytes32 Rkey;
    }
    struct Credential{
        string DId;
        string IssuerId;
        string Type;
        uint Issued;
    }
    struct Wallet{
        uint DId;
        address x;
        bytes32 Ukey;
        bytes32 Rkey;
        string Type;
    }
    Wallet[]private wallets;
    Credential[]private credentials;
    Issuer[]private issuers;
    error NotFound();
    event checkedWallet(string DId,string message);
    mapping(uint=>string)private typeToWallet;
    function typeBuilder()private{
        typeToWallet[0]="User";
        typeToWallet[1]="Issuer";
        typeToWallet[2]="Verifier";
    }
    mapping(address => string[2] ) private SetAddressToCredential;
    function createWallet(uint typeNo)external{
        typeBuilder();
        Wallet storage wallet=wallets.push();
        wallet.DId=uint(keccak256(abi.encode(block.difficulty, block.timestamp)));
        wallet.x=msg.sender;
        wallet.Ukey=keccak256(abi.encode());
        wallet.Rkey=keccak256(abi.encode());
        wallet.Type=typeToWallet[typeNo];
    }
    function setDummyData()external{
        issuers.push(Issuer("issuerDid","Edevlet","1","2")); 
        credentials.push(Credential("credentialDid",issuers[0].DId,"1",block.timestamp));//
        
    }
    function checkWallet(string memory Id)private returns(bool) {   
        for(uint i=0;i<wallets.length;i++){
            if(keccak256(abi.encode(wallets[i].DId))==keccak256(abi.encode(Id))){
                emit checkedWallet(Id, "Wallet has been checked.");
                return true;
            }
        }
        return false;
    }
    function checkIssuer(string memory IssuerDId)private view returns(bytes32){
        for(uint i=0;i<issuers.length;i++){
            if(keccak256(abi.encode(IssuerDId)) == keccak256(abi.encode(issuers[i].DId))){
                return issuers[i].Ukey;
            }
        }
        return "";
    }
    function ReturnCredential(string memory DId)private returns(string[2] memory){
        require(checkWallet(DId) == true,"Invalid Wallet");
        SetAddressToCredential[msg.sender]=[issuers[0].DId,credentials[0].DId];
        return SetAddressToCredential[msg.sender];
    }
    function DecryptObject(string memory EncryptedId)private pure returns(string memory){
        return EncryptedId;  //normalde byte dönmesi gerekiyor. Crypt fonksiyonları yazılana kadar böyle kalacak.
    }
    function Verification(string memory WalletDId)public returns(Credential memory){
        require(checkIssuer(ReturnCredential(WalletDId)[0]) != keccak256(abi.encode("")),"Invalid Issuer");
        string memory value=DecryptObject(ReturnCredential(WalletDId)[1]);
        for(uint i=0;i<credentials.length;i++){
            if(keccak256(abi.encode(value))==keccak256(abi.encode(credentials[i].DId))){
                return credentials[i];
            }
        }
        revert NotFound();
    }
}
