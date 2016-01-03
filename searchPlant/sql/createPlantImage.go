// 写真・スケッなどのイメージデータを取り込む
// 対象フォルダに有るイメージファイルを、ファイル名を和名として取り込む。
// 該当の和名が存在しない場合は、ログを出力して継続する

package main

import (
	"database/sql"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"strings"

	_ "github.com/mattn/go-sqlite3"
)

//TODO 実行時の環境を引数で受け取れるように！
const dbDir = "../../../db/"
const imageDir = dbDir + "images"
const dbName = dbDir + "searchPlant.sqlite3"

var (
	db *sql.DB
	tx *sql.Tx
)

var (
	addr = flag.Bool("addr", false, "find open address and print to final-port.txt")
)

func begin() {
	var err error

	// トランザクションの開始
	tx, err = db.Begin()
	if err != nil {
		log.Fatal(err)
	}
}

func commit() {
	var err error

	// トランザクションの正常終了
	err = tx.Commit()
	if err != nil {
		log.Fatal(err)
	}
}

// 指定されたフォルダー以下にあるイメージファイルでファル名を和名とし持つものをすべてテーブルに登録する
//TODO 同じ和名で複数のイメージがある場合の名前と取り込み方
func importImageFiles(rootPath, searchPath string) {
	var fileInfo os.FileInfo

	fis, err := ioutil.ReadDir(searchPath)

	if err != nil {
		panic(err)
	}

	for _, fi := range fis {
		fullPath := filepath.Join(searchPath, fi.Name())

		if fi.IsDir() {
			importImageFiles(rootPath, fullPath)
		} else {
			var rows *sql.Rows

			rel, err := filepath.Rel(rootPath, fullPath)

			if err != nil {
				panic(err)
			}
			// ファイル名からサフィックスを取り出し、"png"なら画像ファイルとしてテーブルに取り込む
			switch strings.ToLower(filepath.Ext(rel)) {
			case ".png", ".jpg":
				fname := rel[0 : len(rel)-4]
				log.Printf("File(%s) is target File type base(%s)\n", rel, fname)

				// ファイル名（和名）からLnoを取得する。
				str := ""
				str = str + "select lno from searchPlant_1 where name = ?;"

				rows, err = tx.Query(str, fname)
				if err != nil {
					log.Fatalf("%q: '%s'\n", err, str)
				}
				defer rows.Close()

				if rows.Next() {
					var lno int
					err = rows.Scan(&lno)
					if err != nil {
						panic(err)
					}
					log.Printf("lno(%d)\n", lno)

					// TODO ファイルの内容を読み込んでテーブルに登録
					file, err := os.Open(fullPath)
					defer file.Close()

					if err != nil {
						panic(err)
					}
					fileInfo, err = os.Stat(fullPath)
					if err != nil {
						panic(err)
					}
					// 大きいファイルは無視する
					if fileInfo.Size() < 100000 {
						b := make([]byte, fileInfo.Size())
						file.Read(b)
						//TODO テーブルに登録
						str = ""
						//TODO とりあえず枝番は 1 で
						str = str + "insert or replace into plant_image (lno, sno, image) values(?, 1, ?);"

						_, err = tx.Exec(str, lno, b)
						if err != nil {
							log.Fatalf("%q: '%s'\n", err, str)
						}
					} else {
						log.Printf("File(%s)　is too big!\n", rel)
					}
				} else {
					// 無ければログを出して次に進む
					log.Printf("file(%s) is not in database\n", fullPath)
				}
			/*

				//TODO 一定サイズごとに読み込んでDBに書き込む
				b := make([]byte, 1)
				file.Read(b)
			*/
			default:
				log.Printf("File(%s) is unknown File type\n", rel)
			}

			fmt.Println(rel)
		}
	}
}

func main() {
	var err error

	log.Println(">>>>> main in")
	defer log.Println("<<<<< main out")
	flag.Parse()

	_, err = os.Stat(dbName)
	if err != nil {
		// ファイルの情報が取得できないならエラー（存在しないとか）
		log.Fatal(err)
	}

	db, err = sql.Open("sqlite3", dbName)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	begin()
	//TODO テーブルの削除や再作成もここで行う？
	/*
	   -- 写真やイメージなどの取り込み用
	   -- TODO 取り込みのためには、プログラムが必要？
	   drop table if exists plant_image;
	   create table if not exists plant_image (lno number, sno number, image blob, primary key(lno, sno) );


	*/
	importImageFiles(imageDir, imageDir)

	commit()
}
