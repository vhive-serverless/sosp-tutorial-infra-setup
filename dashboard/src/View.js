import React, { useEffect, useState } from 'react';
import { useTable } from 'react-table';
import './Table.css'

function View() {
  const [data, setData] = useState([]);

  useEffect(() => {
    // Fetch data from the Python web server
    fetch('http://130.127.133.65:5000/get_data')
      .then((response) => response.json())
      .then((data) => setData(data));
  }, []);

  const columns = React.useMemo(
    () => [
      {
        Header: 'IP',
        accessor: 'IP',
      },
      {
        Header: 'Ports',
        accessor: 'Ports',
      },
      {
        Header: 'User Email',
        accessor: 'User_Email',
      },
    ],
    []
  );
  

  const {
    getTableProps,
    getTableBodyProps,
    headerGroups,
    rows,
    prepareRow,
  } = useTable({
    columns,
    data,
  });

    return (
        <div className="table-container">
          <div className="table-wrapper">
            <table {...getTableProps()} className="table">
              <thead>
                {headerGroups.map((headerGroup) => (
                  <tr {...headerGroup.getHeaderGroupProps()}>
                    {headerGroup.headers.map((column) => (
                      <th {...column.getHeaderProps()}>{column.render('Header')}</th>
                    ))}
                  </tr>
                ))}
              </thead>
              <tbody {...getTableBodyProps()}>
                {rows.map((row) => {
                  prepareRow(row);
                  return (
                    <tr {...row.getRowProps()}>
                      {row.cells.map((cell) => {
                        return (
                          <td {...cell.getCellProps()}>{cell.render('Cell')}</td>
                        );
                      })}
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>
      );
}

export default View;
