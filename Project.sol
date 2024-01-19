//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
contract Project{
    struct Credential{
        uint CredentialId;
        uint DocId;
        string[] WalletType;
        uint Issued;
    }
    struct Wallet {
        uint DId;
        string[] WalletType; // {"0=User", "1=Issuer", "2=Verifier"} // Question: what about an actor which plays Issuer and Verifier roles in different cases?
        string Name;
        bytes32 Ku;
        bytes32 Kr;
    }
    Credential[]private credentials;
    error NotFound();
    mapping(address=>Wallet) walletMapping;
    mapping(uint=>Credential) credentialMapping;
    mapping(string=>string) typeToWallet;
    mapping(address => bytes32[2] ) private SetAddressToCredential;
    mapping(address => bytes32[2])private savingWallet;
    function createWallet(string[] memory WalletType,string[] memory CredentialType)external{
        uint DId=uint(keccak256(abi.encode(block.difficulty, block.timestamp)));
        bytes32 Ukey=keccak256(abi.encode());
        bytes32 Rkey=keccak256(abi.encode());
        uint credentialDId=uint(keccak256(abi.encode(block.timestamp)));
        string[] memory credentialType=CredentialType;
        uint Issued=block.timestamp;
        Credential memory credential=Credential(credentialDId,DId,credentialType,Issued);
        walletMapping[msg.sender]=Wallet(DId,WalletType,"Name",Ukey,Rkey);
        credentialMapping[credentialDId]=credential;
        SetAddressToCredential[msg.sender]=[keccak256(abi.encode(credentialDId)),Ukey];
    }
    function writeBlockchain()public{
        require(checkWallet(walletMapping[msg.sender].DId),"Invalid Wallet");
        savingWallet[msg.sender]=[keccak256(abi.encode(walletMapping[msg.sender].DId)),walletMapping[msg.sender].Ku];
    }
    function getWallet()external view returns(bytes32[2] memory){
        return savingWallet[msg.sender];
    }
    function checkWallet(uint Id)public pure returns(bool) {   
        require(keccak256(abi.encode(Id))!= keccak256(abi.encode(0)),"Invalid Id");
        return true;
    }
    function ReturnCredential(uint DId)private view returns(bytes32[2] memory){
        require(checkWallet(DId) == true,"Invalid Wallet");
        return SetAddressToCredential[msg.sender];
    }
    function DecryptObject(bytes32 EncryptedId)private pure returns(bytes32){
        return EncryptedId;  //normalde byte dönmesi gerekiyor. Crypt fonksiyonları yazılana kadar böyle kalacak.
    }
    function Verification(uint WalletDId)public view returns(Credential memory){
        bytes32 value=DecryptObject(ReturnCredential(WalletDId)[1]);
        for(uint i=0;i<credentials.length;i++){
            if(keccak256(abi.encode(value))==keccak256(abi.encode(credentials[i].DocId))){
                return credentials[i];
            }
        }
        revert NotFound();
    }
}
