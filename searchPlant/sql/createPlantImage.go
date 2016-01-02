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
	fis, err := ioutil.ReadDir(searchPath)

	if err != nil {
		panic(err)
	}

	for _, fi := range fis {
		fullPath := filepath.Join(searchPath, fi.Name())

		if fi.IsDir() {
			importImageFiles(rootPath, fullPath)
		} else {
			rel, err := filepath.Rel(rootPath, fullPath)

			if err != nil {
				panic(err)
			}
			// TODO ファイル名からサフィックスを取り出し、"png"なら画像ファイルとしてテーブルに取り込む
			// TODO ファイル名（和名）からLnoを取得する。無ければログを出して次に
			// TODO ファイルの内容を読み込んでテーブルに登録

			fmt.Println(rel)
		}
	}
}

func main() {
	//	var rows *sql.Rows
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

	importImageFiles(imageDir, imageDir)

	commit()
}
