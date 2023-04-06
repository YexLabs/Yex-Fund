import * as React from 'react'
import {
    usePrepareContractWrite,
    useContractWrite,

} from 'wagmi'
import {MyTokenAbi} from "../config";

export function MintToken() {
    const { config } = usePrepareContractWrite({
        address: '0xeEE680A857679Dec72864c40C3aA521dDFED6b77',
        abi: MyTokenAbi,
        functionName: 'Mint',
        args: ['0x36De702a11C07777443093a58226f07dEea6dFc8'],
    })
    const { write } = useContractWrite(config)

    return (
        <div>
            <button disabled={!write} onClick={() => write?.()}>
                Mint
            </button>
        </div>
    )
}