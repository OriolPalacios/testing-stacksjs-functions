"use client";

import { openContractDeploy } from "@stacks/connect";
import { useState} from "react";
import { userSession } from "@/lib/Wallet";

export const DeployContractButton = () => {
	const [codeBody, setCodeBody] = useState<string | null>(null);
	const fetchContractCode = async () => {
		const response = await fetch('/api/getContractCode');
		const data = await response.json();
		setCodeBody(data.codeBody);
	};
	const deployContract = () => {
		fetchContractCode();
		if (codeBody) {
			console.log(codeBody);
			openContractDeploy({	
				contractName: `my-contract`,
				codeBody: codeBody,
				onCancel: () => {
					window.alert("Contract deployment was cancelled");
				},
			});
		} else {
			console.error("Contract code body is null");
		}
	};
	return (
		<div className="button-wrapper flex items-center w-full">
			<button type="button" onClick={deployContract} className="w-1/2 text-white bg-blue-500 mt-2 p-2 rounded dark:bg-blue-700">
				Deploy contract
			</button>
		</div>
	);
};