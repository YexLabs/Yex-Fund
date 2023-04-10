import React, { useState } from "react";
import { Document, Page } from "react-pdf/dist/esm/entry.webpack";
import "react-pdf/dist/esm/Page/AnnotationLayer.css";
import pdf from "../whitepaper.pdf";

export default function WhitePaper() {
  const [numPages, setNumPages] = useState(null);
  function onDocumentLoadSuccess({ numPages }) {
    setNumPages(numPages);
  }
  return (
    <div className="mt-24 w-full items-center flex justify-center">
      {" "}
      <Document file={pdf} onLoadSuccess={onDocumentLoadSuccess}>
        {Array.from(new Array(numPages), (el, index) => (
          <Page
            key={`page_${index + 1}`}
            pageNumber={index + 1}
            PageMode="fullScreen"
          />
        ))}
      </Document>
    </div>
  );
}
