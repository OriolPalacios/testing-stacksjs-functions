// pages/api/getContractCode.ts
"use server";

import { NextApiRequest, NextApiResponse } from "next";
import { readFileSync } from "fs";

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  const processRoute = process.cwd();
  const contractPath = "src/contracts/my-nft.clar";
  try {
    const codeBody = readFileSync(contractPath).toString();
    res.status(200).json({ codeBody, processRoute });    
  } catch (error) {
    console.log(error);
    res.status(500).json({ error, processRoute });
  }
}