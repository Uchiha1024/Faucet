import Link from "next/link";
import Image from "next/image";
import GitHub from "@/public/assets/github.png";
import {useState} from "react";
import {useContractContext} from "@/components/context";
import {ManagementRow} from "@/components/managementRow";
import { ethers } from "ethers";
export default function Navbar() {
    const {
        accounts,
        setAccounts,
        JunCoinAddress,
        JUNFaucetAddress,
        setJunCoinAddress,
        setJUNFaucetAddress,
        dripInterval,
        setDripInterval,
        dripLimit,
        setDripLimit,
    } = useContractContext();

    const isConnected = Boolean(accounts[0]);
    const [showManagementTable, setShowManagementTable] = useState(false);
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [editingField, setEditingField] = useState("");
    const [inputValue, setInputValue] = useState("");
    const closeManagementTable = () =>{
        setShowManagementTable(false);
    }

    const openModal = (field) => {
        setEditingField(field);
        setInputValue("");
        setIsModalOpen(true);
    };

    const closeModal = () => {
        setIsModalOpen(false);
    };

    // 连接钱包
    async function connectAccount() {
        try {
            if (window.ethereum) {
                const accounts = await window.ethereum.request({method: 'eth_requestAccounts'});
                setAccounts(accounts);
            } else {
                console.log("Ethereum provider not found.");
            }
        } catch (error) {
            console.error("Failed to connect to accounts:", error);
        }
    }


    // 断开连接
    function disconnectAccount() {
        // 清空已连接的账户
        setAccounts([]);
        console.log("Disconnected from wallet.");
    }

    


    return (

        <div className="flex justify-between items-center text-2xl px-8 py-6  text-pink-400">
            {/*左侧 社交媒体信息*/}
            <div className={"flex"}>
                <Link href="https://github.com/Uchiha1024/Faucet" target="_blank" rel="noopener noreferrer">
                    <div className="flex items-center space-x-2">
                        <Image src={GitHub} alt={"github"} width={36} height={36}/>
                        <span className="font-wq text-3xl px-2 text-white">源代码仓库</span>
                    </div>
                </Link>
            </div>

            {/*右侧 管理页面*/}
            <div className="flex items-center space-x-6 text-2xl">
                {isConnected && (
                    <p className="cursor-pointer"
                       onClick={() => {
                           setShowManagementTable(true)
                       }}
                    >
                        管理页面
                    </p>

                )}


                {isConnected ?
                    (
                        <div className="flex items-center space-x-4">
                            <button
                                className="bg-pink-400 text-white px-6 py-2 rounded-md shadow-lg hover:bg-pink-700 transition duration-300"
                                onClick={disconnectAccount}
                            >
                                断开连接
                            </button>

                        </div>) :
                    (
                        <button
                            className="bg-pink-400 text-white px-6 py-2 rounded-md shadow-lg hover:bg-pink-700 transition duration-300"
                            onClick={connectAccount}
                        >
                            连接钱包

                        </button>
                    )

                }


            </div>


            {showManagementTable && isConnected && (
                <div
                    className="fixed inset-0 flex justify-center items-center bg-black bg-opacity-50 z-40"
                    onClick={closeManagementTable}
                >
                    <div
                        className="text-center bg-transparent p-6 rounded-md shadow-md border-8 border-white border-opacity-25 w-1/2">
                        <h1 className="text-xl mb-8 font-bold bg-[#D6517D] rounded-md shadow-md px-8 py-3">
                            详细信息
                        </h1>
                        <ManagementRow label="当前账户" value={accounts[0]}/>
                        <ManagementRow
                            label="JunCoin代币地址"
                            value={JunCoinAddress}
                            onEdit={() => openModal("LuLuCoinAddress")}
                        />
                        <ManagementRow
                            label="Faucet代币地址"
                            value={JUNFaucetAddress}
                            onEdit={() => openModal("FaucetAddress")}
                        />
                        <ManagementRow
                            label="领取时间间隔"
                            value={dripInterval}
                            onEdit={() => openModal("dripInterval")}
                        />
                        <ManagementRow
                            label="单次最大领取限额"
                            value={parseFloat(ethers.formatUnits(dripLimit, 18))}
                            onEdit={() => openModal("dripLimit")}
                        />

                    </div>

                </div>

            )}

            <div className="fixed inset-0 flex justify-center items-center bg-black bg-opacity-50 z-50">
                <div className="bg-white p-6 rounded-md shadow-lg w-1/3 text-center">
                    <h2 className="text-2xl mb-4">修改 {editingField}</h2>
                    <input
                        className="w-full border text-[#ff2c73] px-3 py-2 rounded-md mb-4"
                        type="text"
                        placeholder={`请输入新的 ${editingField}`}
                        value={inputValue}
                        onChange={(e) => setInputValue(e.target.value)}
                    />
                    <div className="flex justify-end space-x-4">
                        <button
                            className="bg-gray-200 px-4 py-2 rounded-md hover:bg-gray-400"
                            onClick={closeModal}
                        >
                            取消
                        </button>
                        <button
                            className="bg-pink-400 text-white px-4 py-2 rounded-md hover:bg-pink-700"
                            // onClick={}
                        >
                            保存
                        </button>


                    </div>


                </div>


            </div>


        </div>


    )
}