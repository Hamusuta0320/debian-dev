use time::{Date, Month};
#[tokio::main]
async fn main() {
      let date = Date::from_calendar_date(2023, Month::September, 16).unwrap();
    println!("{}", date.next_day().unwrap());
}
