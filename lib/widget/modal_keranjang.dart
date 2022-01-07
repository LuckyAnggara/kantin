FutureBuilder<List<SiapJual>>(
            future: keranjang.getList2,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    if (snapshot.hasData) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${snapshot.data![index].nama}'),
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.remove,
                                      color: Color(0xFFD17E59),
                                      size: 14,
                                    ),
                                  ),
                                  Text(
                                    '${snapshot.data![index].jumlah}',
                                    style: TextStyle(
                                      color: Color(0xFFD17E50),
                                      fontFamily: 'Varela',
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.add,
                                      color: Color(0xFFD17E59),
                                      size: 14,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),