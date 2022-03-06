
const main = async () => {
    const [owner, other] = await hre.ethers.getSigners();
    const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("Contract deployed to: ", nftContract.address);

    const nftContractBalance = await hre.ethers.provider.getBalance(nftContract.address);
    const ownerBalance = await hre.ethers.provider.getBalance(owner.address);
    // const otherBalance = await hre.ethers.provider.getBalance(other.address);
    console.log('NFT Contract balance: ', hre.ethers.utils.formatEther(nftContractBalance));
    console.log('Owner balance: ', hre.ethers.utils.formatEther(ownerBalance));
    // console.log('Other  balance: ', hre.ethers.utils.formatEther(otherBalance));

    // mint nfts
    let nftMintingTxn = await nftContract.makeAnEpicNFT();
    await nftMintingTxn.wait();
    console.log('Minted NFT #1');
    // once more...
    nftMintingTxn = await nftContract.makeAnEpicNFT();
    await nftMintingTxn.wait();
    console.log('Minted NFT #2');

    const count = await nftContract.getTotalNFTsMintedSoFar(owner.address);
    console.log('So far, %d NFTs minted!!!', count);
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
