import React, { ReactNode, useCallback, useState } from "react"
import { fetchNui } from "../utils/fetchNui"

export type ContextType = {
  templates: DocumentTemplate[] | null
  templatesLoading: boolean
  setTemplatesLoading: (isLoading: boolean) => void
  handleGetTemplates: () => void

  documents: AJDocument[] | null
  documentsLoading: boolean
  setDocumentsLoading: (isLoading: boolean) => void
  handleGetDocuments: () => void

  viewDocument: AJDocument | undefined
  setViewDocument: (doc: AJDocument | undefined) => void
  isViewDocOpen: boolean
  setViewDocOpen: (open: boolean) => void

  documentCopies: AJDocument[] | null
  documentCopiesLoading: boolean
  setDocumentCopiesLoading: (isLoading: boolean) => void
  handleGetDocumentCopies: () => void

}

export const Context = React.createContext<ContextType>({} as ContextType)

export const ContextProvider = (props: {children: ReactNode}) => {
  const [templates, setTemplates] = useState<DocumentTemplate[] | null>(null)
  const [templatesLoading, setTemplatesLoading] = useState(false)
  const [documents, setDocuments] = useState<AJDocument[] | null>(null)
  const [documentsLoading, setDocumentsLoading] = useState(false)
  const [documentCopies, setDocumentCopies] = useState<AJDocument[] | null>(null)
  const [documentCopiesLoading, setDocumentCopiesLoading] = useState(false)

  const [viewDocument, setViewDocument] = useState<AJDocument | undefined>()
  const [isViewDocOpen, setViewDocOpen] = useState(false)

  const handleGetTemplates = useCallback(() => {
    fetchNui('getMyTemplates').then(retData => {
      setTemplatesLoading(false)
      setTemplates(retData)
    }).catch(_e => {
      console.error('An error has occured')
    })
  }, [])

  const handleGetDocuments = useCallback(() => {
    fetchNui('getIssuedDocuments').then(retData => {
      setDocumentsLoading(false)
      setDocuments(retData)
    }).catch(_e => {
      console.error('An error has occured')
    })
  }, [])

  const handleGetDocumentCopies = useCallback(() => {
    fetchNui('getPlayerCopies').then(retData => {
      setDocumentCopiesLoading(false)
      setDocumentCopies(retData)
    }).catch(_e => {
      console.error('An error has occured')
    })
  }, [])
  
  return (
    <Context.Provider value={{
      templates,
      templatesLoading,
      setTemplatesLoading,
      handleGetTemplates,
      documents,
      documentsLoading,
      setDocumentsLoading,
      handleGetDocuments,
      viewDocument,
      setViewDocument,
      isViewDocOpen,
      setViewDocOpen,
      documentCopies,
      documentCopiesLoading,
      setDocumentCopiesLoading,
      handleGetDocumentCopies
    }}>
      {props.children}
    </Context.Provider>
  )
}