//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
contract Project{
    struct Issuer{
        uint DId;
        string Name;
        bytes32 Ukey;
        bytes32 Rkey;
    }
    struct Credential{
        uint DId;
        uint walletId;
        string[] Type;
        uint Issued;
        bytes32 Ukey;
        bytes32 Rkey;
    }
    struct Wallet{
        uint DId;
        bytes32 Ukey;
        bytes32 Rkey;
        string Type;
    }
    Wallet[]private wallets;
    Credential[]private credentials;
    Issuer[]private issuers;
    error NotFound();
    mapping(address=>Wallet) walletMapping;
    mapping(uint=>Credential) credentialMapping;
    mapping(uint=>Issuer) issuerMapping;
    uint walletI=0;
    uint credentialI=0;
    uint issuerI=0;

    event checkedWallet(uint DId,string message);
    mapping(string=>string) typeToWallet;
    function typeBuilder()private {
        typeToWallet["0"]="User";
        typeToWallet["1"]="Issuer";
        typeToWallet["2"]="Verifier";
    }
    mapping(address => bytes32[2] ) private SetAddressToCredential;
    mapping(address => bytes32[2])private savingWallet;
    function createWallet(string memory typeNo,string[] memory information)external{
        typeBuilder();
        uint DId=uint(keccak256(abi.encode(block.difficulty, block.timestamp)));
        bytes32 Ukey=keccak256(abi.encode());
        bytes32 Rkey=keccak256(abi.encode());
        string memory Type=typeToWallet[typeNo];
        uint credentialDId=uint(keccak256(abi.encode(block.timestamp)));
        string[] memory credentialType=information;
        uint Issued=block.timestamp;
        Credential memory credential=Credential(credentialDId,DId,credentialType,Issued,Ukey,Rkey);
        walletMapping[msg.sender]=Wallet(DId,Ukey,Rkey,Type);
        credentialMapping[credentialDId]=credential;
        SetAddressToCredential[msg.sender]=[keccak256(abi.encode(credentialDId)),Ukey];
    }
    function writeBlockchain()public{
        require(checkWallet(walletMapping[msg.sender].DId),"Invalid Wallet");
        savingWallet[msg.sender]=[keccak256(abi.encode(walletMapping[msg.sender].DId)),walletMapping[msg.sender].Ukey];
    }
    function getWallet()external view returns(bytes32[2] memory){
        return savingWallet[msg.sender];
    }
    function checkWallet(uint Id)public pure returns(bool) {   
        require(keccak256(abi.encode(Id))!= keccak256(abi.encode(0)),"Invalid Id");
        return true;
    }
    function checkIssuer(bytes32 IssuerDId)private view returns(bytes32){
        require(IssuerDId == keccak256(abi.encode(issuerMapping[uint(IssuerDId)])));
        for(uint i=0;i<issuers.length;i++){
            if(keccak256(abi.encode(IssuerDId)) == keccak256(abi.encode(issuers[i].DId))){
                return issuers[i].Ukey;
            }
        }
        return "";
    }
    function ReturnCredential(uint DId)private view returns(bytes32[2] memory){
        require(checkWallet(DId) == true,"Invalid Wallet");
        return SetAddressToCredential[msg.sender];
    }
    function DecryptObject(bytes32 EncryptedId)private pure returns(bytes32){
        return EncryptedId;  //normalde byte dönmesi gerekiyor. Crypt fonksiyonları yazılana kadar böyle kalacak.
    }
    function Verification(uint WalletDId)public view returns(Credential memory){
        require(checkIssuer(ReturnCredential(WalletDId)[0]) != keccak256(abi.encode("")),"Invalid Issuer");
        bytes32 value=DecryptObject(ReturnCredential(WalletDId)[1]);
        for(uint i=0;i<credentials.length;i++){
            if(keccak256(abi.encode(value))==keccak256(abi.encode(credentials[i].DId))){
                return credentials[i];
            }
        }
        revert NotFound();
    }
}
