use std::str::FromStr;
use sui_json_rpc_types::{SuiObjectDataOptions, SuiObjectResponseQuery};
use sui_sdk::types::base_types::SuiAddress;
use sui_sdk::SuiClientBuilder;

#[tokio::main]
pub(crate) async fn main() -> Result<(), anyhow::Error> {
    let sui = SuiClientBuilder::default()
        .build("https://fullnode.devnet.sui.io:443")
        .await?;
    let address =
        SuiAddress::from_str("0x7e86320466e04f808a5e046a65d1458b3a28def339ea9986e5874496ef66bd08")?;
    let objects = sui
        .read_api()
        .get_owned_objects(
            address,
            Some(SuiObjectResponseQuery::new_with_options(
                SuiObjectDataOptions::new(),
            )),
            None,
            None,
        )
        .await?;
    println!("{:?}", objects.data[0].data.clone().unwrap().object_id);
    Ok(())
}
