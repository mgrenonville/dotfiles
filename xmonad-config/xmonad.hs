module Main (main) where

import qualified Data.Map as M

import XMonad.Prompt
import XMonad.Prompt.Ssh


import System.IO
import XMonad
import XMonad.Layout.Accordion
import XMonad.Layout.PerWorkspace
import XMonad.Actions.CycleWS
import XMonad.Actions.GridSelect
import XMonad.Actions.SpawnOn
import XMonad.Actions.UpdatePointer
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ICCCMFocus
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Grid
import XMonad.Layout.Named
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout.ToggleLayouts
import XMonad.Util.Run(spawnPipe)
import XMonad.Actions.Plane
import qualified XMonad.StackSet as W
import Graphics.X11.ExtraTypes.XF86
import XMonad.Prompt
import XMonad.Prompt.Window

import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.LayoutModifier

import           XMonad.Hooks.FadeInactive             ( fadeInactiveLogHook )
-- Imports for Polybar --
import qualified Codec.Binary.UTF8.String              as UTF8
import qualified DBus                                  as D
import qualified DBus.Client                           as D


import XMonad.Layout.Renamed
import XMonad.Actions.TagWindows
import qualified XMonad.Layout.Groups.Examples as E
import XMonad.Layout.Groups.Helpers


import qualified XMonad.Layout.Groups as G

import XMonad.Layout.Simplest ( Simplest(Simplest) )
import XMonad.Layout.ZoomRow

myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#0000BE"


devWorkspaces = ["`","1","2","3","4","5","6","7","8","9","0","-","="]
prodWorkspaces = ["p`","p1","p2","p3","p4","p5","p6","p7","p8","p9","p0","p-","p="]

myWorkspaces = devWorkspaces ++ prodWorkspaces

full = noBorders Full





-- instance Eq a => EQF GroupEQ (G.Group l a) where
    -- eq _ (G.G l1 _) (G.G l2 _) = G.sameID l1 l2

zoomRowG :: (Eq a, Show a, Read a, Show (l a), Read (l a))
            => ZoomRow E.GroupEQ (G.Group l a)
zoomRowG = zoomRowWith E.GroupEQ




tabOfAccordions = G.group  column $ x
    where
      column = renamed [CutWordsLeft 2, PrependWords "ZoomColumn"] $ Accordion
      x = tabbed shrinkText defaultTheme


tabOfAccordions2 = G.group  column $ x
          where
            column = renamed [CutWordsLeft 2, PrependWords "ZoomColumn"] $ Accordion
            x = zoomRowG



layouts =  onWorkspaces ["1"] ((full ||| tiled) ||| tabbed shrinkText defaultTheme ||| avoidStruts (Mirror tiled) ) $
           onWorkspaces  ["2","3"] ( avoidStruts ( tiled ||| Mirror tiled |||  Accordion)) $
	         avoidStruts ( tiled ||| Mirror tiled ||| full ) ||| full
  where
 -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
 -- The default number of windows in the master pane
     nmaster = 1
 -- Default proportion of screen occupied by master pane
     ratio   = 1/2
 -- Percent of screen to increment by when resizing panes
     delta   = 3/100

myLayoutHook = (toggleLayouts $ avoidStruts full) $ ( layouts )


myManageHook = composeAll
    [ className =? "MPlayer"          --> doFloat
    , title     =? "VLC media player" --> doFloat
    , className =? "Iceweasel"          --> doF (W.shift "1" )
    , className =? "Pidgin"           --> doF (W.shift "5" )
    , className =? "jetbrains-idea"           --> doF (W.shift "1" )
    ]


newKeys x = M.union (M.fromList (myKeys x)) (keys defaultConfig x)
myKeys conf@(XConfig {XMonad.modMask = modMask}) =
    [ ((modMask .|. shiftMask, xK_l), spawn "xscreensaver-command -select 2 ;  xscreensaver-command -lock")
-- Allow full screen mode
    , ((modMask, xK_f ), sendMessage ToggleLayout)
    , ((0, xF86XK_HomePage), spawn "~/bin/dump_cmus.sh")
    , ((0, xF86XK_Explorer), spawn "firefox https://www.youtube.com/watch?v=kxopViU98Xo ;xtrlock -f")
    , ((modMask .|. shiftMask, xK_g     ), windowPromptGoto  defaultXPConfig )
    , ((modMask .|. shiftMask, xK_b     ), windowPromptBring defaultXPConfig)
    , ((0, xF86XK_Mail), spawn "xscreensaver-command -select 2 ; xscreensaver-command -lock")
-- Return to last workspace
    , ((modMask ,  xK_b ), toggleWS )
    , ((modMask ,  xK_y ), spawn "xdotool click 2" )
    , ((modMask  , xK_Left  ), prevWS )
    , ((modMask  , xK_Right ), nextWS )
   -- , ((0, xF86XK_AudioRaiseVolume),   spawn "amixer set Master 2%+")
    --, ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 2%-")
    , ((modMask .|. controlMask, xK_s), sshPrompt defaultXPConfig)
    , ((modMask .|. controlMask, xK_j), moveToGroupUp False)
    , ((modMask .|. controlMask, xK_k), moveToGroupDown False)

    , ((modMask, xK_m), spawn "~/bin/toggleMic.sh")
    , ((modMask, xK_Return), swapMaster)
    , ((modMask, xK_k), focusUp)
    , ((modMask, xK_j), focusDown)

    , ((modMask .|. controlMask, xK_f), E.toggleColumnFull)
    , ((modMask .|. controlMask, xK_Left), focusGroupUp)
    , ((modMask .|. controlMask, xK_Right), focusGroupDown)

    , ((modMask              , xK_BackSpace), focusUrgent)
    ]
    ++
     [ ((keyMask .|. modMask, keySym), function (Lines 2) Finite direction)
    | (keySym, direction) <- zip [xK_Left .. xK_Down] $ enumFrom ToLeft
    , (keyMask, function) <- [(0, planeMove), (shiftMask, planeShift)]
    ]
    ++
    --
    -- mod-{z,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{z,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_z, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    ++
    -- Map Super_R to prod workspaces, see .Xmodmap
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (prodWs(workspaces(conf))) numFnKeys,
          (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (devWs(workspaces(conf))) numQwerty,
          (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
          where
          devWs array = take (div (length array ) 2) array
          prodWs array = drop (div (length array ) 2) array

-- keys between ` and = on an qwerty keyboard. 13 worspaces.
numQwerty = [0x60,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x30,0x2d,0x3d]
-- Escape to F12
numFnKeys = [0xff1b,xK_F1,xK_F2,xK_F3,xK_F4,xK_F5,xK_F6,xK_F7,xK_F8,xK_F9,xK_F10,xK_F11,xK_F12]


------------------------------------------------------------------------
-- Polybar settings (needs DBus client).
--
mkDbusClient :: IO D.Client
mkDbusClient = do
  dbus <- D.connectSession
  D.requestName dbus (D.busName_ "org.xmonad.log") opts
  return dbus
 where
  opts = [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str =
  let opath  = D.objectPath_ "/org/xmonad/Log"
      iname  = D.interfaceName_ "org.xmonad.Log"
      mname  = D.memberName_ "Update"
      signal = D.signal opath iname mname
      body   = [D.toVariant $ UTF8.decodeString str]
  in  D.emit dbus $ signal { D.signalBody = body }

polybarHook :: D.Client -> PP
polybarHook dbus =
  let wrapper c s | s /= "NSP" = wrap ("%{F" <> c <> "} ") " %{F-}" s
                  | otherwise  = mempty
      blue   = "#2E9AFE"
      gray   = "#7F7F7F"
      orange = "#ea4300"
      purple = "#9058c7"
      red    = "#722222"
  in  def { ppOutput          = dbusOutput dbus
          , ppCurrent         = wrapper blue
          , ppVisible         = wrapper gray
          , ppUrgent          = wrapper orange
          , ppHidden          = wrapper gray
         -- , ppHiddenNoWindows = wrapper red
          , ppTitle           = wrapper purple . shorten 60
          }

myPolybarLogHook dbus = myLogHook <+> dynamicLogWithPP (polybarHook dbus)
-- [module/xmonad]
-- type = custom/script
-- exec = ~/bin/xmonad-log
-- tail = true

-----------------------------------------------------------------------------}}}
-- STARTUPHOOK                                                               {{{
--------------------------------------------------------------------------------
myStartupHook = do
  setWMName "LG3D"
  spawn "~/.config/polybar/launch.sh --forest"

main = do
      dbus <- mkDbusClient
      xmonad $ ewmh $ docks $ withUrgencyHook dzenUrgencyHook { args = ["-bg", "darkgreen", "-xs", "1"] }  $ defaultConfig {
                          manageHook = myManageHook <+> manageDocks <+> manageHook defaultConfig,
                          keys = newKeys,
                          modMask = mod4Mask,
                          normalBorderColor  = myNormalBorderColor,
                          focusedBorderColor = myFocusedBorderColor,
                          layoutHook = myLayoutHook,
                          startupHook = myStartupHook,
                          terminal = "urxvt",
                          workspaces = myWorkspaces,
                          logHook =  (myPolybarLogHook dbus)
                          >> updatePointer (0.5, 0.5) (0.5,0.5)  >> takeTopFocus

}



------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = fadeInactiveLogHook 0.9
