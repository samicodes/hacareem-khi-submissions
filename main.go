package main

import (
	"github.com/ant0ine/go-json-rest/rest"
	_ "github.com/go-sql-driver/mysql"
	"github.com/jinzhu/gorm"
	"log"
	"net/http"
	"github.com/mmcloughlin/geohash"
	"time"
	"strconv"
)

func main() {

	i := Impl{}
	i.InitDB()
	i.InitSchema()

	api := rest.NewApi()
	api.Use(rest.DefaultDevStack...)
	router, err := rest.MakeRouter(
		rest.Post("/suggestionsforuser", i.GetSuggestionsForUser),
		rest.Post("/addsuggestions", i.AddSuggestion),
		rest.Post("/add/ride", i.AddRide),
		rest.Get("/loadpredict/:time", i.GetLoadForTime),
		
	)
	if err != nil {
		log.Fatal(err)
	}
	api.SetApp(router)
	log.Fatal(http.ListenAndServe(":8081", api.MakeHandler()))
}

type Location struct {
	Display string `json: "display"`
	Geohash string `json: "geohash"`
	Latitude float64 `json: "latitude"`
	Longitude float64 `json: "longitude"`
}

type Ride struct {
	Dropoff Location `json: "dropoff"`
	PickupTime int64 `json: "pickUpTime"`
	Pickup Location `json: "pickup"`
	RideId string `json: "rideId"`
	UserId string `json: "userId"`
}

type UserInfo struct {
	Userid string `sql:"size:20" json:"userid"`
	Latitude float64 `"json:"latitude"`
	Longitude float64 `"json:"latitude"`
}

type Suggestion struct {
	Id        int64     `json:"id"`
	Userid string    `sql:"size:20" json:"userid"`
	Geohash string `sql:"size:20" json:"geohash"`
	Hour int `sql:"size:20" json:"hour"`
	Day string `sql:"size:20" json:"day"`
	Score int64 `json:"score"`
	Pickuptime int64 `json:"pickuptime"`
	Dropoffaddress string `sql:"size:1024" json:"dropoffaddress"`
	Dropofflat float64 `json:"dropofflat"`
	Dropofflong float64 `json:"dropofflong"`
	Dropoffgeohash string `sql:"size:20" json:"dropoffgeohash"`
}

type Impl struct {
	DB *gorm.DB
}

func (i *Impl) InitDB() {
	var err error
	i.DB, err = gorm.Open("mysql", "remotein_careem:careem@(192.185.165.193:3306)/remotein_careem?charset=utf8&parseTime=True")
	if err != nil {
		log.Fatalf("Got error when connect database, the error is '%v'", err)
	}
	i.DB.LogMode(true)
}

func (i *Impl) InitSchema() {
	i.DB.AutoMigrate(&Suggestion{})
}

func (i*Impl) GetSuggestionsForUser(w rest.ResponseWriter, r *rest.Request) {
	userInfo := UserInfo{}
	if err := r.DecodeJsonPayload(&userInfo); err != nil {
		rest.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	//calculate lat long geohash using precison 7. 
	var userLocGeoHash = geohash.EncodeWithPrecision(userInfo.Latitude, userInfo.Longitude, 7)
	t := time.Now();
	
	suggestions := []Suggestion{}
	//Where("ABS(hour-"+strconv.Itoa(t.Hour())+") < 2").
	//Where("day==" + t.Weekday().String()).
	if err := i.DB.Where(&Suggestion{Userid:userInfo.Userid, Geohash:userLocGeoHash}).Where("day=\"" + t.Weekday().String()+"\"").Order("score desc").Find(&suggestions).Error; err != nil {
		rest.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	//popularSugg := []Suggestion{}
	/*if err := i.DB.Raw("SELECT * FROM `suggestions` where day = "+"\"" + t.Weekday().String()+"\"" +" GROUP by dropoffgeohash order by count(dropoffaddress) desc limit 0, 3").Scan(&popularSugg).Error; err != nil {
		rest.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	result := append(suggestions, popularSugg...)*/
	w.WriteJson(&suggestions)
}

func (i*Impl) AddSuggestion(w rest.ResponseWriter, r *rest.Request) {
	suggestion := Suggestion{}
	if err := r.DecodeJsonPayload(&suggestion); err != nil {
		rest.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	if err := i.DB.Save(&suggestion).Error; err != nil {
		rest.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.WriteJson(&suggestion)
}

func (i *Impl) AddRide(w rest.ResponseWriter, r *rest.Request) {
	ride := Ride{}
	if err := r.DecodeJsonPayload(&ride); err != nil {
		rest.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	
	suggestion := Suggestion{}
	suggestion.Userid = ride.UserId;
	suggestion.Geohash = geohash.EncodeWithPrecision(ride.Pickup.Latitude, ride.Pickup.Longitude, 7)
	t := time.Unix(ride.PickupTime,0);
	//w.WriteJson(&time);
	
	suggestion.Hour = t.Hour()
	suggestion.Day = t.Weekday().String()
	suggestion.Pickuptime = ride.PickupTime
	suggestion.Dropoffaddress = ride.Dropoff.Display
	suggestion.Dropofflat = ride.Dropoff.Latitude
	suggestion.Dropofflong = ride.Dropoff.Longitude
	suggestion.Dropoffgeohash = geohash.EncodeWithPrecision(ride.Dropoff.Latitude, ride.Dropoff.Longitude, 7)

	//fmt.Print(ride.Dropoff.Lat)
	if err := i.DB.Save(&suggestion).Error; err != nil {
		rest.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.WriteJson(&suggestion)
	
}

type Result struct {
	Count int `json: "count"`
}
func (i *Impl) GetLoadForTime(w rest.ResponseWriter, r *rest.Request) {
	timestamp, err := strconv.ParseInt(r.PathParam("time"),10, 64)
	if err != nil {
		
	}
	t := time.Unix(timestamp ,0)
	var count Result
	
	i.DB.Raw( "select count(*) as count from suggestions where day=\""+t.Weekday().String()+"\" and hour=" + strconv.Itoa( t.Hour()) ).Scan(&count) 
	w.WriteJson(&count)
}