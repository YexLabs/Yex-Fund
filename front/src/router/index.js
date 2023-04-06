import {BrowserRouter as Router, Link, Route, Routes} from "react-router-dom"

import App from "../components/App";
import {SendTransaction} from "../components/Transaction";
import {MintToken} from "../components/Mint";

export function BaseRoutes() {
    return (
        <Router>
            <Routes>
                <Route path="/" element={<App />}>
                    <Route path="/BuySell" element={<SendTransaction />} />
                    <Route path="/TokenList" element={<MintToken />} />
                </Route>
            </Routes>
        </Router>
    )
}