exception NoRoot

switch ReactDOM.querySelector("#root_react_element") {
| Some(root) => ReactDOM.render(<Demo />, root)
| None => raise(NoRoot)
}
