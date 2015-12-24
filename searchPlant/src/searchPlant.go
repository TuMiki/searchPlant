// HTML版の植物検索
// 現段階ではいくつかの理由で、GO言語で日本語を扱うのが困難なため
// HTMLで記述しアプリケーションとしてまとめる。

package main

import (
	"database/sql"
	"flag"
	//	"fmt"
	"html/template"
	"log"
	"net/http"
	"net/http/httputil"
	"os"

	"strings"

	_ "github.com/mattn/go-sqlite3"
)

//TODO 実行時の環境を引数で受け取れるように！
const dbName = "../../../db/" + "searchPlant.sqlite3"
const htmlPath = "../html/"

var (
	db *sql.DB
	tx *sql.Tx
)

var (
	addr = flag.Bool("addr", false, "find open address and print to final-port.txt")
)

// Item 検索条件の情報
type Item struct {
	Lno  int
	Name string
	// 茎
	AA, AB, AC string // 形, 表面, 切口
	// 葉
	CA, CB, CC, CD, CE, CF, CG, CH, CI, CJ, CK string // 形, 先, もと, ふち, 脈, 柄, 托葉, つき方, におい, 冬の木の葉, 草の寿命
	// 花
	EA, EB, EC, ED, EE, EF, EG, EH, EI, EJ, EK string // 色, つき方, 形, 花びらの数, がくの形, がくの数, ほうがくの外側, おしべの形, おしべの数, めしべの先, 子房の位置
	// 果実
	GA, GB string // 熟した色, 実の形
	// 花期・分布
	HA, HB, HC, HD string // 花期, 分布, 環境, 自生栽培

}

// Page parameters
type Page struct {
	Items []Item
}

var page *Page = &Page{}

func search(w http.ResponseWriter, r *http.Request) {
	log.Printf(">>>>> search in\n")
	defer log.Println("<<<<< search out")

	r.ParseForm()

	log.Printf("%s : %s%s : Header(%s) Form(%s), len(%d)\n",
		r.Method,
		r.RemoteAddr,
		r.URL.Path,
		r.Header.Get("Content-Type"),
		r.Form,
		len(r.Form),
	)

	httputil.DumpRequest(r, false)

	renderTemplate(w, "searchPlant", page)
}

func result_list(w http.ResponseWriter, r *http.Request) {
	var rows *sql.Rows
	var err error

	log.Printf(">>>>> result_list in\n")
	defer log.Println("<<<<< result_list out")

	r.ParseForm()

	log.Printf("%s : %s%s : Header(%s) Form(%s), len(%d)\n",
		r.Method,
		r.RemoteAddr,
		r.URL.Path,
		r.Header.Get("Content-Type"),
		r.Form,
		len(r.Form),
	)

	if r.Method != "POST" {
		return
	}

	page.Items = []Item{}

	sqlWhere := ""

	// 名前検索の方法を取り込む
	cond := ""
	t := r.Form["cond"]
	if t != nil {
		cond = t[0]
	}
	t = r.Form["name"]
	if t != nil && t[0] != "" {
		// 検索方法に従って文字列検索を行う
		switch cond {
		default:
			// C か未知の文字列なら、完全一致
			sqlWhere = sqlWhere + " and name = '" + t[0] + "'"
		case "A":
			sqlWhere = sqlWhere + " and name like '" + t[0] + "%'"
		case "B":
			sqlWhere = sqlWhere + " and name like '%" + t[0] + "%'"
		}
	}
	// i が連想配列の添字
	for i, v := range r.Form {
		if i != "name" && i != "cond" {

			sqlWhere = sqlWhere + " and "
			sqlWhere = sqlWhere + "( "
			// 連想配列の値は、大きさ1の配列として渡されてくる
			for j, c := range strings.Split(v[0], "") {
				if j > 0 {
					sqlWhere = sqlWhere + " and "
				}
				sqlWhere = sqlWhere + i + c + " = '" + c + "'"
			}
			sqlWhere = sqlWhere + ")"
		}
	}

	str :=
		`select
	a.lno,
	b.name,
	-- 茎 > 形
	aaA || aaB || aaC || aaD || aaE || aaF || aaG aa,
	-- 茎 > 表面
	abA || abB || abC || abD ab,
	-- 茎 > 切口
	acA || acB || acC || acD || acE ac,
	-- 葉 > 形
	caA || caB || caC || caD || caE || caF || caG || caH || caI ca,
	-- 葉 > 先
	cbA || cbB || cbC cb,
	-- 葉 > もと
	ccA || ccB || ccC cc,
	-- 葉 > ふち
	cdA || cdB || cdC || cdD || cdE || cdF cd,
	-- 葉 > 脈
	ceA || ceB || ceC || ceD || ceE ce,
	-- 葉 > 柄
	cfA || cfB || cfC || cfD || cfE || cfF || cfG cf,
	-- 葉 > 托葉
	cgA || cgB || cgC || cgD cg,
	-- 葉 > つき方
	chA || chB || chC || chD || chE || chF ch,
	-- 葉 > におい
	ciA ci,
	-- 葉 > 冬の木の葉
	cjA || cjB cj,
	-- 葉 > 草の寿命
	ckA || ckB || ckC ck,
	-- 花 > 色
	eaA || eaB || eaC || eaD ea,
	-- 花 > つき方
	ebA || ebB || ebC || ebD || ebE || ebF || ebG || ebH || ebI || ebJ eb,
	-- 花 > 形
	ecA || ecB || ecC || ecD || ecE ec,
	-- 花 > 花びらの数
	edA || edB || edC || edD || edE || edF || edG ed,
	-- 花 > がくの形
	eeA || eeB || eeC ee,
	-- 花 > がくの数
	efA || efB || efC || efD || efE || efF || efG ef,
	-- 花 > ほうがくの外側
	egA || egB || egC eg,
	-- 花 > おしべの形
	ehA || ehB || ehC || ehD || ehE || ehF || ehG || ehH || ehI eh,
	-- 花 > おしべの数
	eiA || eiB || eiC || eiD || eiE || eiF || eiG ei,
	-- 花 > めしべの先
	ejA || ejB || ejC || ejD || ejE || ejF || ejG ej,
	-- 花 > 子房の位置
	ekA || ekB || ekC ek,
	-- 果実 > 熟した色
	gaA || gaB || gaC || gaD || gaE ga,
	-- 果実 > 実の形
	gbA || gbB || gbC || gbD || gbE || gbF || gbG gb,
	-- 花期・分布 > 花期
	haA || haB || haC || haD ha,
	-- 花期・分布 > 分布
	hbA || hbB || hbC || hbD || hbE || hbF || hbG || hbH || hbI hb,
	-- 花期・分布 > 環境
	hcA || hcB || hcC || hcD || hcE hc,
	-- 花期・分布 > 自生栽培
	hdA || hdB || hdC hd
from
	plant_trait a,
	searchPlant_1 b
where
	a.lno = b.lno
`
	str = str + sqlWhere
	log.Printf("sql[%s]\n", str)

	begin() // トランザクションの開始

	rows, err = db.Query(str)
	if err != nil {
		log.Fatalf("%q: '%s'\n", err, str)
	}
	defer rows.Close()

	log.Println("検索結果出力")

	for rows.Next() {
		var lno int
		var name string
		// 茎
		var aa, ab, ac string // 形, 表面, 切口
		// 葉
		var ca, cb, cc, cd, ce, cf, cg, ch, ci, cj, ck string // 形, 先, もと, ふち, 脈, 柄, 托葉, つき方, におい, 冬の木の葉, 草の寿命
		// 花
		var ea, eb, ec, ed, ee, ef, eg, eh, ei, ej, ek string // 色, つき方, 形, 花びらの数, がくの形, がくの数, ほうがくの外側, おしべの形, おしべの数, めしべの先, 子房の位置
		// 果実
		var ga, gb string // 熟した色, 実の形
		// 花期・分布
		var ha, hb, hc, hd string // 花期, 分布, 環境, 自生栽培

		//TODO 項目が多いので配列にしたいが・・・Scan 以外の取り込み要調査
		err = rows.Scan(&lno, &name,
			&aa, &ab, &ac, // 茎: 形, 表面, 切口
			&ca, &cb, &cc, &cd, &ce, &cf, &cg, &ch, &ci, &cj, &ck, // 葉: 形, 先, もと, ふち, 脈, 柄, 托葉, つき方, におい, 冬の木の葉, 草の寿命
			&ea, &eb, &ec, &ed, &ee, &ef, &eg, &eh, &ei, &ej, &ek, // 花: 色, つき方, 形, 花びらの数, がくの形, がくの数, ほうがくの外側, おしべの形, おしべの数, めしべの先, 子房の位置
			&ga, &gb, // 果実: 熟した色, 実の形
			&ha, &hb, &hc, &hd) // 花期・分布: 花期, 分布, 環境, 自生栽培
		if err != nil {
			log.Fatalf("%q\n", err)
		}
		log.Printf("%d, %s %s\n", lno, name,
			"|"+aa+"|"+ab+"|"+ac+ // 茎: 形, 表面, 切口
				"|"+ca+"|"+cb+"|"+cc+"|"+cd+"|"+ce+"|"+cf+"|"+cg+"|"+ch+"|"+ci+"|"+cj+"|"+ck+ // 葉: 形, 先, もと, ふち, 脈, 柄, 托葉, つき方, におい, 冬の木の葉, 草の寿命
				"|"+ea+"|"+eb+"|"+ec+"|"+ed+"|"+ee+"|"+ef+"|"+eg+"|"+eh+"|"+ei+"|"+ej+"|"+ek+ // 花: 色, つき方, 形, 花びらの数, がくの形, がくの数, ほうがくの外側, おしべの形, おしべの数, めしべの先, 子房の位置
				"|"+ga+"|"+gb+ // 果実: 熟した色, 実の形
				"|"+ha+"|"+hb+"|"+hc+"|"+hd) // 花期・分布: 花期, 分布, 環境, 自生栽培
		page.Items = append(page.Items, Item{lno, name,
			aa, ab, ac, // 茎: 形, 表面, 切口
			ca, cb, cc, cd, ce, cf, cg, ch, ci, cj, ck, // 葉: 形, 先, もと, ふち, 脈, 柄, 托葉, つき方, におい, 冬の木の葉, 草の寿命
			ea, eb, ec, ed, ee, ef, eg, eh, ei, ej, ek, // 花: 色, つき方, 形, 花びらの数, がくの形, がくの数, ほうがくの外側, おしべの形, おしべの数, めしべの先, 子房の位置
			ga, gb, // 果実: 熟した色, 実の形
			ha, hb, hc, hd}) // 花期・分布: 花期, 分布, 環境, 自生栽培
	}
	rows.Close()

	commit() // トランザクションの正常終了

	//	httputil.DumpRequest(r, false)

	// 結果をTemplateを利用してtableのTR以下のタグに整形、画面側で検索行の下に追加一気に追加
	templates := template.Must(template.ParseFiles(htmlPath + "result_list.html"))

	err = templates.ExecuteTemplate(w, "result_list.html", page)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

var templates = template.Must(template.ParseFiles(htmlPath + "searchPlant.html"))

func renderTemplate(w http.ResponseWriter, tmpl string, p *Page) {
	log.Printf(">>>>> renderTemplate in : %s\n", tmpl)
	defer log.Println("<<<<< renderTemplate out")
	err := templates.ExecuteTemplate(w, tmpl+".html", p)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

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

	http.HandleFunc("/searchPlant/", search)
	http.HandleFunc("/searchPlant/result_list.html", result_list)
	//TODO 色などを変更するためにもローカルに持ちたい。以前、用いたものは、エラーとなるので要再挑戦！
	//	http.HandleFunc("/jquery-ui-1.11.4.custom-1/", func(w http.ResponseWriter, r *http.Request) {
	//	http.ServeFile(w, r, r.URL.Path[1:])
	//	})

	//TODO この中でリクエスト街のループになっているらしい。ポートの準備に時間がかかるらしく、応答するまでに時間が掛かる。
	// 準備完了時にメッセージを表示したい。

	//TODO 終了時に強制終了となっているため、DBの終了処理が行われていない模様。要確認。そして、安全な終了方法を要調査
	err = http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
