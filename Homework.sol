//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
contract Project{
    struct Credential{
        uint CredentialId;
        uint DocId;
        string WalletType;
        uint Issued;
    }
    struct Wallet {
        uint DId;
        string WalletType; // {"0=User", "1=Issuer", "2=Verifier"} // Question: what about an actor which plays Issuer and Verifier roles in different cases?
        string Name;
        bytes32 Ku;
        bytes32 Kr;
    }
    function TypeBuilder()private{
        typeToWallet["0"]="User";
        typeToWallet["1"]="Issuer";
        typeToWallet["2"]="Verifier";
        typeToCredential["0"]="Diploma";
        typeToCredential["1"]="License";
    }
    mapping(string=>string) typeToWallet;
    mapping(string=>string) typeToCredential;
    Credential[]private credentials;
    error NotFound();
    mapping(address=>Wallet) walletMapping;
    mapping(uint=>Credential) credentialMapping;
    mapping(address => bytes32[2] ) private SetAddressToCredential;
    mapping(address => bytes32[2])private savingWallet;
    function createWallet(string memory WalletType,string memory CredentialType)external{
        TypeBuilder();
        uint DId=uint(keccak256(abi.encode(block.difficulty, block.timestamp)));
        bytes32 Ukey=keccak256(abi.encode());
        bytes32 Rkey=keccak256(abi.encode());
        walletMapping[msg.sender]=Wallet(DId,typeToWallet[WalletType],"Name",Ukey,Rkey);
        if(keccak256(abi.encode(WalletType)) == keccak256(abi.encode("0")) || keccak256(abi.encode(WalletType))==keccak256(abi.encode("1"))){
            uint credentialDId=uint(keccak256(abi.encode(block.timestamp)));
            string memory credentialType=typeToCredential[CredentialType];
            uint Issued=block.timestamp;
            Credential memory credential=Credential(credentialDId,DId,credentialType,Issued);
            credentialMapping[credentialDId]=credential;
        }
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
    function DecryptObject(uint EncryptedId)private pure returns(uint){
        return EncryptedId;  //normalde byte dönmesi gerekiyor. Crypt fonksiyonları yazılana kadar böyle kalacak.
    }
    function Verification(uint WalletDId,uint CredentialId)public view returns(Credential memory){
        require(walletMapping[msg.sender].DId == WalletDId,"Wallet was not found.");
        require(keccak256(abi.encode(credentialMapping[CredentialId])) != keccak256(abi.encode(Credential(0,0,"",0))) ,"Credential was not found");
        uint value=DecryptObject(CredentialId);
        return credentialMapping[value];
    }
}