# Welcome to the kanaverse!

## About

[**kana**](https://kanaverse.org/kana) is a web application for interactive analysis of single-cell genomics data.
Its unique selling point is that all computation is done on the client machine, rather than being transferred to a backend server;
this simplifies deployment, avoids latency and data ownership issues, and provides greater scalability across users.
Check out [our manuscript](https://www.biorxiv.org/content/10.1101/2022.03.02.482701v1) for more details.

![Overview and Analysis of Zillinois Lung dataset](https://raw.githubusercontent.com/kanaverse/kana/master/assets/v3_release.gif)

This organization manages the code for the **kana** application as well as the underlying packages and resources.
Most code is written in Javascript, with a sprinkling of C++ for WebAssembly and R for some preprocessing.

## Key packages

[**bakana**](https://github.com/kanaverse/bakana) ("backend **kana**") manages the analysis pipeline and results for the web application.
It can also be used to execute the same analysis on a backend server via Node.js.

[**scran.js**](https://github.com/kanaverse/scran.js) implements various methods for single-cell data analysis,
by compiling various C/C++ libraries such as [**libscran**](https://github.com/LTLA/libscran) to WebAssembly.

[**kanapi**](https://github.com/kanaverse/kanapi) provides a more traditional backend for **kana**,
allowing maintainers to run **bakana** on a server and transfer results to the client via websockets.

## Contact

This organization is managed by [Aaron "A-bomb" Lun](https://github.com/LTLA) and [Jayaram "Rowling" Kancherla](https://github.com/jkanche).
