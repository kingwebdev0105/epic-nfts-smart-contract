
const main = async () => {
    const [owner, other] = await hre.ethers.getSigners();
    const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("Contract deployed to: ", nftContract.address);
    const nftContractBalance = await hre.ethers.provider.getBalance(nftContract.address);
    const ownerBalance = await hre.ethers.provider.getBalance(owner.address);
    console.log('NFT Contract balance: ', hre.ethers.utils.formatEther(nftContractBalance));
    console.log('Owner balance: ', hre.ethers.utils.formatEther(ownerBalance));
    
    // mint nfts
    let nftMintingTxn = await nftContract.makeAnEpicNFT();
    await nftMintingTxn.wait();
    // once more...
    nftMintingTxn = await nftContract.makeAnEpicNFT();
    await nftMintingTxn.wait();
}

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.error(error);
        process.exit(1);
    }
}

runMain();
