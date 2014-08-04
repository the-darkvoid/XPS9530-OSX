/* SSDT-bcm943xx.dsl -- SSDT injector for Broadcom bcm943xx WIFI
 *
 * Credits to Toleda, Pike R. Alpha
 * Derived from https://github.com/toleda/wireless_half-mini
 */

DefinitionBlock ("SSDT-bcm943xx.aml", "SSDT", 1, "toleda", "ami8arpt", 0x00003000)
{
    Method (_SB.PCI0.RP04.PXSX._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (LEqual (Arg2, Zero))
        {
            Return (Buffer (One) { 0x03 })
        }

        Return (Package (0x0C)
        {
            "AAPL,slot-name", 
            "AirPort", 

            "built-in", 
            Buffer (One) { 0x00 },
            
            "device_type",
            "AirPort",
            
            "model",
            "Broadcom BCM943xx 802.11 a/b/g/n Wireless Network Controller",
            
            "name",
            "AirPort Extreme",
            
            "compatible",
            "pci14e4,43a0"
        })
    }
}
