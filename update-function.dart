 getAllBookDetails() async {
    if (_startup) {
      var serverBooks = await _apiService.getAllBooks();
	  
      _bookService.wipeAllBooks();
	  
      for (Book book in serverBooks) { _bookService.insertBook(book); }
      await _broadcasts.ready;
      _broadcasts.stream.listen((data) {
        String operation = json.decode(data)['operation'];
        if (operation == "post") { _bookService.insertBook(Book.fromJson(json.decode(data)['payload'])); } 
        else if (operation == "put") { _bookService.updateBook(Book.fromJson(json.decode(data)['payload'])); }
        else if (operation == "delete") { _bookService.deleteBook(json.decode(data)['payload']); }
      });
      _startup = false;
    }
	
	var books = await _bookService.readAllBooks();
	
    _bookList = <Book>[];
    books.forEach((book) {
      setState(() {
        var bookModel = Book();
        bookModel.id = book['id'];
        bookModel.title = book['title'];
        bookModel.author = book['author'];
        _bookList.add(bookModel);
      });
    });
