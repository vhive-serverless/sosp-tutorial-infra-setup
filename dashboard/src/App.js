import { Route, Routes } from "react-router-dom"
import EmailForm  from "./EmailForm"
import View  from "./View"

export default function App() {
  return (
    <Routes>
      <Route path="/" element={<EmailForm />} />
      <Route path="/view" element={<View />} />
    </Routes>
  )
}


